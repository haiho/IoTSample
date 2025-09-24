import Alamofire
import Foundation

// MARK: - Base Request Protocols

protocol APIRequest: Encodable {}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
// MARK: - Hàm buildParams thêm token và req_time tự động
func buildParams<T: Encodable>(_ request: T) -> [String: Any] {
    var dict = request.toDictionary() ?? [:]

    let reqTime = Int64(Date().timeIntervalSince1970 * 1000)
    let token =
        UserDefaultsManager.shared.authToken
        ?? "\(reqTime)\(APIConfig.secretKey)".md5()

    dict["token"] = token
    dict["req_time"] = reqTime
    return dict
}
// MARK: - Base API Response

struct BaseAPIResponse<T: Decodable>: Decodable {
    let msg: String?
    let code: String?
    let loginBy: String?
    let af: Int?
    let sharedCp: Int?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case msg
        case code
        case loginBy = "login_by"
        case af
        case sharedCp = "shared_cp"
        case data
    }
}

// MARK: - HTTPMethod Enum

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH

    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .GET: return .get
        case .POST: return .post
        case .PUT: return .put
        case .DELETE: return .delete
        case .PATCH: return .patch
        }
    }
}

// MARK: - APIError

enum APIError: Error, LocalizedError {
    case invalidURL
    case encodingError(Error)
    case decodingError(Error)
    case statusCodeError(Int)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL không hợp lệ."
        case .encodingError(let e):
            return "\(e.localizedDescription)"
        case .decodingError(let e):
            return "\(e.localizedDescription)"
        case .statusCodeError(let code):
            return "Status code: \(code)"
        case .underlying(let e): return "\(e.localizedDescription)"
        }
    }
}

// MARK: - APIEndpoint

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let body: APIRequest?

    var urlString: String {
        return "\(APIConfig.baseURL)\(path)"
    }

    init(
        path: String,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        body: APIRequest? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
    }
}

// MARK: - APIServiceProtocol

protocol APIServiceProtocol {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        body: APIRequest?,
        responseModel: T.Type
    ) async throws -> T
}
// MARK: - APIService (Alamofire Implementation)

final class APIService: APIServiceProtocol {

    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        body: APIRequest?,
        responseModel: T.Type
    ) async throws -> T {

        // 1. Validate URL
        let urlString = APIConfig.baseURL + path
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        // 2. Prepare method & headers
        let afMethod = method.alamofireMethod
        var headers = defaultHeaders()
        headers["Content-Type"] = "application/x-www-form-urlencoded"

        // 3. Logging
        print("➡️ URL: \(url.absoluteString)")
        print("➡️ Method: \(afMethod.rawValue)")
        print("➡️ Headers: \(headers)")

        let dataResponse: DataResponse<Data, AFError>

        if let body = body {
            let params = buildParams(body)
            print("➡️ Parameters: \(params)")

            dataResponse = await AF.request(
                url,
                method: afMethod,
                parameters: params,
                encoding: URLEncoding.default,
                headers: HTTPHeaders(headers)
            )
            .validate()
            .serializingData()
            .response
        } else {
            dataResponse = await AF.request(
                url,
                method: afMethod,
                headers: HTTPHeaders(headers)
            )
            .validate()
            .serializingData()
            .response
        }

        // 4. Decode response or throw error
        switch dataResponse.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decodingError(error)
            }
        case .failure(let afError):
            if let statusCode = dataResponse.response?.statusCode {
                throw APIError.statusCodeError(statusCode)
            } else {
                throw APIError.underlying(afError)
            }
        }
    }

    // MARK: - Default Headers

    private func defaultHeaders() -> [String: String] {
        [
            "User-Agent": UserAgent.toString(),
            "x-timezone": TimeZone.current.identifier,
            "x-timestamp": "\(Int64(Date().timeIntervalSince1970 * 1000))",
            "accept-language": Locale.current.language.languageCode?.identifier
                ?? "en",
            "x-doctella-app-id": "26c301b1ebe247e6bc5f49b15c159571",
            "x-doctella-app-key": "26cb713e-a350-4139-962d-b3b75958d0d1",
        ]
    }

    private func mergeHeaders(
        _ defaultHeaders: [String: String],
        with customHeaders: [String: String]
    ) -> [String: String] {
        var merged = defaultHeaders
        customHeaders.forEach { merged[$0.key] = $0.value }
        return merged
    }
}
