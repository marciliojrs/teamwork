import RxSwift

public struct Multipart {
    let data: [Data]
    let key: String
    let mime: String
}

public struct Request: CustomStringConvertible {
    enum Method: String { case get = "GET", post = "POST", delete = "DELETE", patch = "PATCH", put = "PUT" }

    let type: Request.Method
    let path: String
    let components: [String: String?]
    let body: [String: Any]?
    let multiPartData: [Multipart]?
    let cacheable: Bool
    let downloadable: Bool
    let headers: [String: String]?

    public var description: String {
        var desc = "path: \(path);"

        desc += " method: \(type.rawValue);"
        if let body = body { desc += " body: \(body);" }
        if let headers = headers { desc += " headers: \(headers);" }

        return desc
    }
}

public enum NetworkError: Swift.Error, Equatable {
    case invalidUrl
    case httpError(Int)
    case error(Error)
    case unknownError

    static public func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl): return true
        case (let .httpError(code1), let .httpError(code2)): return code1 == code2
        case (.error, error): return true
        case (.unknownError, .unknownError): return true
        default: return false
        }
    }
}

public protocol NetworkRequestMakerType: AutoMockable {
    func make(request: Request) -> Observable<Data>
}

public struct NetworkRequestMaker: NetworkRequestMakerType {
    private let baseUrl: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    private let session: URLSession

    init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
        self.session = URLSession.shared
    }

    public func make(request: Request) -> Observable<Data> {
        if request.downloadable {
            return download(request: request)
        } else if request.multiPartData != nil {
            return upload(request: request)
        } else {
            return data(request: request)
        }
    }

    private func data(request: Request) -> Observable<Data> {
        guard var components = URLComponents(string: baseUrl) else {
            return .error(NetworkError.invalidUrl)
        }

        components.queryItems = request.components.count > 0
            ? request.components.map { ($0.key, $0.value) }.map(URLQueryItem.init)
            : nil

        guard let path = components.url?.appendingPathComponent(request.path).absoluteString,
            let url = URL(string: path) else {
            return .error(NetworkError.invalidUrl)
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        urlRequest.httpMethod = request.type.rawValue
        if request.type == .post || request.type == .patch {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.body ?? [:])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        for (key, value) in request.headers ?? [:] {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        let cacheData = URLCache.shared.cachedResponse(for: urlRequest)?.data
        let networkResponse = session.rx.response(request: urlRequest)
            .flatMap { (response, data) -> Observable<Data> in
                if 200...299 ~= response.statusCode {
                    print(["response": response.statusCode,
                                 "data": String(data: data, encoding: .utf8) ?? "",
                                 "request": request])
                    return .just(data)
                } else {
                    print(["response": response.statusCode,
                                  "data": String(data: data, encoding: .utf8) ?? "",
                                  "request": request])
                    if let cache = cacheData, request.cacheable {
                        return .just(cache)
                    } else {
                        return .error(NetworkError.httpError(response.statusCode))
                    }
                }
            }.subscribeOn(scheduler)

        if request.cacheable {
            let cacheResponse: Observable<Data> = cacheData != nil ? .just(cacheData!) : .empty()
            return cacheResponse.concat(networkResponse)
        } else {
            return networkResponse
        }
    }

    private func upload(request: Request) -> Observable<Data> {
        guard let url = URL(string: (baseUrl + "/" + request.path)) else {
            return .error(NetworkError.invalidUrl)
        }

        let multipartFormData = request.multiPartData?.map { multipart -> [MultipartFormData] in
            return multipart.data.map { data in
                MultipartFormData(data: data, key: multipart.key,
                                  name: "\(data.hashValue).jpg", mimeType: multipart.mime)
            }
        }.flatMap { $0 }

        return session.rx.upload(url: url, parameters: nil, headers: request.headers, formData: multipartFormData)
            .flatMap { (response, data) -> Observable<Data> in
                if 200...299 ~= response.statusCode {
                    print(["response": response.statusCode,
                                 "data": String(data: data, encoding: .utf8) ?? "",
                                 "request": request])
                    return .just(data)
                } else {
                    print(["response": response.statusCode,
                                  "data": String(data: data, encoding: .utf8) ?? "",
                                  "request": request])
                    return .error(NetworkError.httpError(response.statusCode))
                }
            }.subscribeOn(scheduler)
    }

    private func download(request: Request) -> Observable<Data> {
        guard var components = URLComponents(string: baseUrl) else {
            return .error(NetworkError.invalidUrl)
        }

        components.queryItems = request.components.count > 0
            ? request.components.map { ($0.key, $0.value) }.map(URLQueryItem.init)
            : nil

        guard let path = components.url?.appendingPathComponent(request.path).absoluteString,
            let url = URL(string: path) else {
            return .error(NetworkError.invalidUrl)
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        urlRequest.httpMethod = request.type.rawValue

        let cacheData = URLCache.shared.cachedResponse(for: urlRequest)?.data
        let networkResponse = session.rx.response(request: urlRequest)
            .flatMap { (response, data) -> Observable<Data> in
                if 200...299 ~= response.statusCode {
                    return .just(data)
                } else {
                    if let cache = cacheData, request.cacheable {
                        return .just(cache)
                    } else {
                        return .error(NetworkError.httpError(response.statusCode))
                    }
                }
            }.subscribeOn(scheduler)

        if request.cacheable {
            let cacheResponse: Observable<Data> = cacheData != nil ? .just(cacheData!) : .empty()
            return cacheResponse.concat(networkResponse)
        } else {
            return networkResponse
        }
    }
}
