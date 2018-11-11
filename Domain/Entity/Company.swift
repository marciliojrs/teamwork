//sourcery: AutoInit
public struct Company: AutoEquatable {
    public let id: String
    public let name: String

    static let empty = Company(id: "", name: "")

// sourcery:inline:auto:Company.AutoInit
// swiftlint:disable superfluous_disable_command
// swiftlint:disable:next line_length
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
// swiftlint:enable superfluous_disable_command
// sourcery:end
}
