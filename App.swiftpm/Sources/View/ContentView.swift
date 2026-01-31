import CounterFeature
import SwiftUI

public struct ContentView: View {
  @StateObject private var counter = Counter()

  public init() {}

  public var body: some View {
    VStack(spacing: 20) {
      Text("Counter App")
        .font(.largeTitle)
        .fontWeight(.bold)

      Text("\(self.counter.count)")
        .font(.system(size: 60, weight: .bold, design: .monospaced))
        .padding()

      HStack(spacing: 40) {
        Button(action: {
          self.counter.decrement()
        }) {
          Image(systemName: "minus.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundColor(.red)
        }

        Button(action: {
          self.counter.increment()
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundColor(.green)
        }
      }
    }
    .padding()
  }
}
