import Testing
@testable import View

@Test @MainActor func testContentViewInit() async throws {
  let view = ContentView()
  #expect(view is ContentView)
}
