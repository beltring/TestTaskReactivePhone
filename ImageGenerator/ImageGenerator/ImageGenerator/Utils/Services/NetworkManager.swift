import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    typealias ResponseCompletionClosure = ((ImageGeneratorResponse?, Error?) -> Void)

    func generateImageRequest(text: String, completion: ResponseCompletionClosure?) {
        guard let request = createDummyImageRequest(text: text) else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            let responseModel = ImageGeneratorResponse(imageData: data, request: request.url?.absoluteString ?? "")
            completion?(responseModel, nil)
        }
        dataTask.resume()
    }

    private func createDummyImageRequest(text: String) -> URLRequest? {
        let urlString = "https://dummyimage.com/1024x1024&text=\(text)"
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
