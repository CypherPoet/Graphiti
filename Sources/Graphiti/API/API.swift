import GraphQL
import NIO

public protocol API {
    associatedtype Resolver
    associatedtype ContextType
    var resolver: Resolver { get }
    var schema: Schema<Resolver, ContextType> { get }
}

public extension API {
    func execute(
        request: String,
        context: ContextType,
        on eventLoopGroup: EventLoopGroup,
        variables: [String: Map] = [:],
        operationName: String? = nil
    ) -> EventLoopFuture<GraphQLResult> {
        return schema.execute(
            request: request,
            resolver: resolver,
            context: context,
            eventLoopGroup: eventLoopGroup,
            variables: variables,
            operationName: operationName
        )
    }

    func subscribe(
        request: String,
        context: ContextType,
        on eventLoopGroup: EventLoopGroup,
        variables: [String: Map] = [:],
        operationName: String? = nil
    ) -> EventLoopFuture<SubscriptionResult> {
        return schema.subscribe(
            request: request,
            resolver: resolver,
            context: context,
            eventLoopGroup: eventLoopGroup,
            variables: variables,
            operationName: operationName
        )
    }
}

#if compiler(>=5.5) && canImport(_Concurrency)

    public extension API {
        @available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
        func execute(
            request: String,
            context: ContextType,
            on eventLoopGroup: EventLoopGroup,
            variables: [String: Map] = [:],
            operationName: String? = nil
        ) async throws -> GraphQLResult {
            return try await schema.execute(
                request: request,
                resolver: resolver,
                context: context,
                eventLoopGroup: eventLoopGroup,
                variables: variables,
                operationName: operationName
            ).get()
        }

        @available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
        func subscribe(
            request: String,
            context: ContextType,
            on eventLoopGroup: EventLoopGroup,
            variables: [String: Map] = [:],
            operationName: String? = nil
        ) async throws -> SubscriptionResult {
            return try await schema.subscribe(
                request: request,
                resolver: resolver,
                context: context,
                eventLoopGroup: eventLoopGroup,
                variables: variables,
                operationName: operationName
            ).get()
        }
    }

#endif
