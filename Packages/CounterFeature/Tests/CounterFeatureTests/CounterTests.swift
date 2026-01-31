import CounterFeature
import XCTest

@MainActor
final class CounterTests: XCTestCase {
    func testIncrement() {
        let counter = Counter()
        XCTAssertEqual(counter.count, 0)
        counter.increment()
        XCTAssertEqual(counter.count, 1)
    }

    func testDecrement() {
        let counter = Counter()
        counter.increment()
        counter.increment()
        XCTAssertEqual(counter.count, 2)
        counter.decrement()
        XCTAssertEqual(counter.count, 1)
    }
}
