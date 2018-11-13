//sourcery: AutoInit
public struct Project: AutoEquatable {
    public enum Status: String {
        case active, archived, current, late, completed

        var order: Int {
            switch self {
            case .active: return 1
            case .archived: return 2
            case .current: return 3
            case .late: return 4
            case .completed: return 5
            }
        }
    }

    public let id: String
    public let starred: Bool
    public let status: Project.Status
    public let logo: URL?
    public let name: String
    public let description: String
    public let company: Company

    static let empty: Project = Project(
        id: "",
        starred: false,
        status: .active,
        logo: URL(string: "https://dummyimage.com/200/fff/fff.png")!,
        name: "",
        description: "",
        company: Company.empty
    )

// sourcery:inline:auto:Project.AutoInit
// swiftlint:disable superfluous_disable_command
// swiftlint:disable:next line_length
    public init(id: String, starred: Bool, status: Project.Status, logo: URL?, name: String, description: String, company: Company) {
        self.id = id
        self.starred = starred
        self.status = status
        self.logo = logo
        self.name = name
        self.description = description
        self.company = company
    }
// swiftlint:enable superfluous_disable_command
// sourcery:end
}
