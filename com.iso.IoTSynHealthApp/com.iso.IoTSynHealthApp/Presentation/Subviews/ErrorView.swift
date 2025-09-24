import SwiftUI

enum ErrorType {
    case decoding
    case noInternet
    case backend(Int)
}

struct ErrorView: View {

    let title: String
    let message: String

    init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    init(error: ErrorType) {
        switch error {
        case .decoding:
            self.title = "Something went wrong"
            self.message = "Please contact developer"
        case .noInternet:
            self.title = "No Internet"
            self.message = "Please check your internet connection"
        case .backend(let code):
            self.title = "Server Error"
            switch code {
            case 403:
                self.message = "Github API limit reached, wait a second"
            case 503:
                self.message = "Service unavailable"
            default:
                self.message = "Server error code: \(code)"
            }
        }
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()

            Text(message)
                .padding()
        }
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ErrorView(error: .backend(503))
//            ErrorView(title: "Custom Error", message: "This is a custom error message")
//        }
//    }
//}
