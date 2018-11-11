extension String {
    var base64: String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }

        return nil
    }
}

extension Optional where Wrapped == String {
    var safe: String {
        return self ?? ""
    }
}
