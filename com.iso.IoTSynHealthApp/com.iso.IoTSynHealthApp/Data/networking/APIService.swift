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
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL không hợp lệ."
        case .encodingError(let e):
            return e.localizedDescription
        case .decodingError(let e):
            return e.localizedDescription
        case .statusCodeError(let code): return "Lỗi status code: \(code)"
        case .underlying(let e): return e.localizedDescription
        case .custom(let msg): return msg
        }
    }
}

// MARK: - JSONDecoder Debug Extension

extension JSONDecoder {
    func decodeSafe<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try self.decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            print(
                "❌ Key not found: \(key.stringValue), context: \(context.debugDescription)"
            )
            if let json = String(data: data, encoding: .utf8) {
                print("📦 JSON: \(json)")
            }
            throw APIError.decodingError(
                DecodingError.keyNotFound(key, context)
            )
        } catch let DecodingError.typeMismatch(type, context) {
            print(
                "❌ Type mismatch: \(type), context: \(context.debugDescription)"
            )
            throw APIError.decodingError(
                DecodingError.typeMismatch(type, context)
            )
        } catch let DecodingError.valueNotFound(value, context) {
            print(
                "❌ Value not found: \(value), context: \(context.debugDescription)"
            )
            throw APIError.decodingError(
                DecodingError.valueNotFound(value, context)
            )
        } catch {
            print("❌ Unknown decode error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
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
    func request<T: BaseAPIResponse & Decodable>(
        path: String,
        method: HTTPMethod,
        body: APIRequest?,
        responseModel: T.Type
    ) async throws -> T
}

// MARK: - Base Response Model
class BaseAPIResponse: Decodable {
    let msg: String?
    let code: String
    let loginBy: String?

    enum CodingKeys: String, CodingKey {
        case msg, code
        case loginBy = "login_by"
    }

    var isSuccess: Bool {
        code == "0"
    }
}
final class APIService: APIServiceProtocol {
    func request<T: BaseAPIResponse & Decodable>(
        path: String,
        method: HTTPMethod,
        body: APIRequest?,
        responseModel: T.Type
    ) async throws -> T {
        let urlString = APIConfig.baseURL + path
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let afMethod = method.alamofireMethod
        var headers = defaultHeaders()
        headers["Content-Type"] = "application/x-www-form-urlencoded"

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
            ).validate().serializingData().response
        } else {
            dataResponse = await AF.request(
                url,
                method: afMethod,
                headers: HTTPHeaders(headers)
            ).validate().serializingData().response
        }

        switch dataResponse.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let responseObj = try decoder.decode(T.self, from: data)

                guard responseObj.code == "0" else {
                    throw APIError.custom(
                        responseObj.msg ?? "Lỗi không xác định từ server"
                    )
                }
                return responseObj

            } catch {
                print(error.localizedDescription)
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
}
