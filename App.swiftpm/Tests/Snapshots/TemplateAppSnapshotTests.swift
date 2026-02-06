import SwiftUI
import UIKit
import XCTest

@testable import View

@MainActor
final class TemplateAppSnapshotTests: XCTestCase {
  func testRecordContentViewSnapshot() throws {
    let snapshotURL = SnapshotOutputPath.snapshotsDirectory
      .appendingPathComponent("content-view.png")

    try FileManager.default.createDirectory(
      at: SnapshotOutputPath.snapshotsDirectory,
      withIntermediateDirectories: true
    )

    let contentView = ContentView()
      .frame(width: 390, height: 844)
      .background(Color.white)

    let renderer = ImageRenderer(content: contentView)
    renderer.scale = 2

    let image = try XCTUnwrap(renderer.uiImage, "Snapshot rendering failed.")
    let pngData = try XCTUnwrap(image.pngData(), "PNG encoding failed.")

    try pngData.write(to: snapshotURL, options: .atomic)
    XCTAssertTrue(FileManager.default.fileExists(atPath: snapshotURL.path))
  }
}

private enum SnapshotOutputPath {
  static let projectRoot: URL = {
    URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
  }()

  static let snapshotsDirectory = projectRoot.appendingPathComponent(
    "App.swiftpm/Tests/Snapshots/snapshots",
    isDirectory: true
  )
}
