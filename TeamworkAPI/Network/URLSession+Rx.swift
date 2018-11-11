import RxCocoa
import RxSwift
import Foundation

extension Reactive where Base: URLSession {
    func upload(url: URL,
                parameters: [String: Any]?,
                headers: [String: String]?,
                formData: [MultipartFormData]?) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable.create { (observer) in
            let task = self.base.uploadMultipartTask(
                with: url,
                parameters: parameters,
                headers: headers,
                formData: formData,
                completionHandler: { (data, response, error) in
                    guard let response = response, let data = data else {
                        observer.on(.error(error ?? RxCocoaURLError.unknown))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
                        return
                    }

                    observer.on(.next((httpResponse, data)))
                    observer.on(.completed)
                }
            )

            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
}
