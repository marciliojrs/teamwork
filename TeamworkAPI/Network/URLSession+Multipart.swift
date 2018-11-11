//  That's an update of https://github.com/robertmryan/NSURLSessionMultipart

import Foundation
import MobileCoreServices

public struct MultipartFormData {
    public let data: Data
    public let key: String
    public let name: String
    public let mimeType: String
}

extension URLSession {

    /// Create multipart upload task.
    ///
    /// If using background session, you must supply a `localFileURL` with a `URL` where the
    /// body of the request should be saved.
    ///
    /// - parameter url:                The `URL` for the web service.
    /// - parameter parameters:         The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter fileKeyName:        The name of the key to be used for files included in the request.
    /// - parameter fileURLs:           An optional array of `URL` for local files to be included in `NSData`.
    /// - parameter localFileURL:       The optional file `URL` where the body of the request should be stored.
    ///                                 If using non-background session, pass `nil` for the `localFileURL`.
    ///
    /// - returns:                      The `URLSessionUploadTask` that was created. This throws error if there was
    ///                                 problem opening file in the `fileURLs`.
    public func uploadMultipartTask(with url: URL,
                                    parameters: [String: Any]?,
                                    headers: [String: String]?,
                                    fileKeyName: String?,
                                    fileURLs: [URL]?,
                                    localFileURL: URL? = nil) throws -> URLSessionUploadTask {
        let (request, data) = createMultipartRequest(
            with: url,
            parameters: parameters,
            headers: headers,
            formData: try generateFormData(with: fileKeyName, fileURLs: fileURLs)
        )

        if let localFileURL = localFileURL {
            try data.write(to: localFileURL, options: .atomic)
            return uploadTask(with: request, fromFile: localFileURL)
        }

        return uploadTask(with: request, from: data)
    }

    /// Create multipart upload task.
    ///
    /// This should not be used with background sessions. Use the rendition without
    /// `completionHandler` if using background sessions.
    ///
    /// - parameter url:                The `URL` for the web service.
    /// - parameter parameters:         The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter fileKeyName:        The name of the key to be used for files included in the request.
    /// - parameter fileURLs:           An optional array of `URL` for local files to be included in `Data`.
    /// - parameter completionHandler:  The completion handler to call when the load request is complete.
    ///                                 This handler is executed on the delegate queue.
    ///
    /// - returns:                      The `URLRequest` that was created. This throws error if there was problem
    ///                                 opening file in the `fileURLs`.
    //swiftlint:disable:next function_parameter_count
    public func uploadMultipartTask(with url: URL,
                                    parameters: [String: Any]?,
                                    headers: [String: String]?,
                                    fileKeyName: String?,
                                    fileURLs: [URL]?,
                                    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        throws -> URLSessionUploadTask {
        let (request, data) = createMultipartRequest(
            with: url,
            parameters: parameters,
            headers: headers,
            formData: try generateFormData(with: fileKeyName, fileURLs: fileURLs)
        )

        return uploadTask(with: request, from: data, completionHandler: completionHandler)
    }

    /// Create multipart upload task.
    ///
    /// If using background session, you must supply a `localFileURL` with a `URL` where the
    /// body of the request should be saved.
    ///
    /// - parameter url:                The `URL` for the web service.
    /// - parameter parameters:         The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter formData:           The optional array of `MultipartFormData` items to be passed in request body.
    /// - parameter localFileURL:       The optional file `URL` where the body of the request should be stored.
    ///                                 If using non-background session, pass `nil` for the `localFileURL`.
    ///
    /// - returns:                      The `URLSessionUploadTask` that was created. This throws error if there was
    ///                                 problem saving request body in disk.
    public func uploadMultipartTask(
        with url: URL,
        parameters: [String: Any]?,
        headers: [String: String]?,
        formData: [MultipartFormData]?,
        localFileURL: URL? = nil) throws -> URLSessionUploadTask {
        let (request, data) = createMultipartRequest(with: url,
                                                     parameters: parameters,
                                                     headers: headers,
                                                     formData: formData)

        if let localFileURL = localFileURL {
            try data.write(to: localFileURL, options: .atomic)
            return uploadTask(with: request, fromFile: localFileURL)
        }

        return uploadTask(with: request, from: data)
    }

    /// Create multipart upload task.
    ///
    /// If using background session, you must supply a `localFileURL` with a `URL` where the
    /// body of the request should be saved.
    ///
    /// - parameter url:                The `URL` for the web service.
    /// - parameter parameters:         The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter formData:           The optional array of `MultipartFormData` items to be passed in request body.
    /// - parameter completionHandler:  The completion handler to call when the load request is complete.
    ///                                 This handler is executed on the delegate queue.
    ///
    /// - returns:                      The `URLSessionUploadTask` that was created. This throws error if there was
    ///                                 problem saving request body in disk.
    public func uploadMultipartTask(
        with url: URL,
        parameters: [String: Any]?,
        headers: [String: String]?,
        formData: [MultipartFormData]?,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        let (request, data) = createMultipartRequest(with: url,
                                                     parameters: parameters,
                                                     headers: headers,
                                                     formData: formData)

        return uploadTask(with: request, from: data, completionHandler: completionHandler)
    }

    /// Create multipart data task.
    ///
    /// This should not be used with background sessions. Use `uploadMultipartTask` with
    /// `localFileURL` and without `completionHandler` if using background sessions.
    ///
    /// - parameter URL:                The `URL` for the web service.
    /// - parameter parameters:         The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter fileKeyName:        The name of the key to be used for files included in the request.
    /// - parameter fileURLs:           An optional array of `URL` for local files to be included in `Data`.
    ///
    /// - returns:                      The `URLRequest` that was created. This throws error if there was problem
    ///                                 opening file in the `fileURLs`.
    public func dataMultipartTask(with url: URL,
                                  parameters: [String: Any]?,
                                  headers: [String: String]?,
                                  fileKeyName: String?,
                                  fileURLs: [URL]?) throws -> URLSessionDataTask {
        var (request, data) = createMultipartRequest(
            with: url,
            parameters: parameters,
            headers: headers,
            formData: try generateFormData(with: fileKeyName, fileURLs: fileURLs)
        )

        request.httpBody = data
        return dataTask(with: request)
    }

    /// Create multipart data task.
    ///
    /// This should not be used with background sessions. Use `uploadMultipartTask` with
    /// `localFileURL` and without `completionHandler` if using background sessions.
    ///
    /// - parameter URL:                The `NSURL` for the web service.
    /// - parameter parameters:         The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter fileKeyName:        The name of the key to be used for files included in the request.
    /// - parameter fileURLs:           An optional array of `NSURL` for local files to be included in `NSData`.
    /// - parameter completionHandler:  The completion handler to call when the load request is complete.
    ///                                 This handler is executed on the delegate queue.
    ///
    /// - returns:                      The `NSURLRequest` that was created. This throws error if there was problem
    ///                                 opening file in the `fileURLs`.
    // swiftlint:disable:next function_parameter_count
    public func dataMultipartTask(with url: URL,
                                  parameters: [String: Any]?,
                                  headers: [String: String]?,
                                  fileKeyName: String?,
                                  fileURLs: [URL]?,
                                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        throws -> URLSessionDataTask {
        var (request, data) = createMultipartRequest(
            with: url,
            parameters: parameters,
            headers: headers,
            formData: try generateFormData(with: fileKeyName, fileURLs: fileURLs)
        )

        request.httpBody = data
        return dataTask(with: request, completionHandler: completionHandler)
    }

    /// Create upload request.
    ///
    /// With upload task, we return separate `URLRequest` and `Data` to be passed to
    /// `uploadTask(with:fromData:)`.
    ///
    /// - parameter URL:          The `URL` for the web service.
    /// - parameter parameters:   The optional dictionary of parameters to be passed in the body of the request.
    /// - parameter headers:            The headers you may use with the request
    /// - parameter formData:     An optional array of `MultipartFormData` to be included in request body.
    ///
    /// - returns:                The `URLRequest` anda `Data` that was created.
    public func createMultipartRequest(with url: URL,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?,
                                       formData: [MultipartFormData]?) -> (URLRequest, Data) {
        let boundary = URLSession.generateBoundaryString()

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let headers = headers {
            headers.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let data = createMultipartBody(with: parameters, formData: formData, boundary: boundary)

        return (request, data)
    }

    /// Generates an array of `MultipartFormData`.
    ///
    /// - parameter fileKeyName: The name of the key to be used for files included in the request.
    /// - parameter fileURLs:    An optional array of `URL` for local files to be included in request body.
    ///
    /// - returns:               An optional array of `MultipartFormData`. This throws error if there was problem
    ///                          opening tile in the `fileURLs` array.
    private func generateFormData(with fileKeyName: String?, fileURLs: [URL]?) throws -> [MultipartFormData]? {
        guard let fileKeyName = fileKeyName else {
            throw NSError(
                domain: Bundle.main.bundleIdentifier ?? "URLSession+Multipart",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "If fileURLs supplied, fileKeyName must not be nil"]
            )
        }

        let formData = try fileURLs?.map { fileURL -> MultipartFormData in
            let filename = fileURL.lastPathComponent
            guard let data = try? Data(contentsOf: fileURL) else {
                throw NSError(domain: Bundle.main.bundleIdentifier ?? "NSURLSession+Multipart",
                              code: -1,
                              userInfo: [NSLocalizedDescriptionKey: "Unable to open \(fileURL.path)"])
            }

            let mimetype = URLSession.mimeType(for: fileURL.path)

            return MultipartFormData(data: data, key: fileKeyName, name: filename, mimeType: mimetype)
        }

        return formData
    }

    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary of parameters to be included.
    /// - parameter formData:     The array of `MultipartFormData` items to be included
    /// - parameter boundary:     The multipart/form-data boundary.
    ///
    /// - returns:                The `Data` of the body of the request.
    private func createMultipartBody(with parameters: [String: Any]?,
                                     formData: [MultipartFormData]?,
                                     boundary: String) -> Data {
        var body = Data()

        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }

        if let formData = formData {
            for item in formData {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.name)\"\r\n")
                body.append("Content-Type: \(item.mimeType)\r\n\r\n")
                body.append(item.data)
                body.append("\r\n")
            }
        }

        body.append("--\(boundary)--\r\n")
        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    private class func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable
    ///                           to determine mime type.
    class func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }

        return "application/octet-stream"
    }

}

extension Data {
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to Data, and then add that
    /// data to self. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    public mutating func append(_ string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}
