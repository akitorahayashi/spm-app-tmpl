import SwiftUI

public struct ContentView: View {
  public init() {}

  public var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "swift")
        .font(.system(size: 80))
        .foregroundColor(.orange)

      Text("Hello, World!")
        .font(.largeTitle)
        .fontWeight(.bold)

      Text("SwiftPM Template App")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
