public protocol Paginatable: ForwardPaginatable, BackwardPaginatable {}

public struct PaginationArguments: Paginatable {
    public let first: Int?
    public let last: Int?
    public let after: String?
    public let before: String?

    init(_ arguments: Paginatable) {
        first = arguments.first
        last = arguments.last
        after = arguments.after
        before = arguments.before
    }

    init(_ arguments: ForwardPaginatable) {
        first = arguments.first
        last = nil
        after = arguments.after
        before = nil
    }

    init(_ arguments: BackwardPaginatable) {
        first = nil
        last = arguments.last
        after = nil
        before = arguments.before
    }
}
