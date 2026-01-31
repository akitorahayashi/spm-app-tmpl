import Foundation

@MainActor
public class Counter: ObservableObject {
    @Published public private(set) var count: Int = 0

    public init() {}

    public func increment() {
        count += 1
    }

    public func decrement() {
        count -= 1
    }
}
