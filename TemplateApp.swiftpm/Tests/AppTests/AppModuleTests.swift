import Testing
@testable import View

@Test @MainActor func testContentViewInit() async throws {
  _ = ContentView()
  #expect(true)
}
