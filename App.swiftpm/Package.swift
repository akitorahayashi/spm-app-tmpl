// swift-tools-version: 6.0

import AppleProductTypes
import PackageDescription

let package = Package(
  name: "TemplateApp",
  platforms: [
    .iOS("16.0"),
  ],
  products: [
    .iOSApplication(
      name: "TemplateApp",
      targets: ["App"],
      bundleIdentifier: "com.akitorahayashi.TemplateApp",
      teamIdentifier: "XXXXXXXXXX",
      displayVersion: "1.0",
      bundleVersion: "1",
      appIcon: .asset("AppIcon"),
      accentColor: .presetColor(.blue),
      supportedDeviceFamilies: [
        .pad,
        .phone,
      ],
      supportedInterfaceOrientations: [
        .portrait,
        .landscapeRight,
        .landscapeLeft,
        .portraitUpsideDown(.when(deviceFamilies: [.pad])),
      ]
    ),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: ["View"],
      path: "Sources/App",
      resources: [
        .process("Assets.xcassets"),
      ]
    ),
    .target(
      name: "View",
      path: "Sources/View"
    ),
    .testTarget(
      name: "AppTests",
      dependencies: ["View"],
      path: "Tests/AppTests"
    ),
  ],
  swiftLanguageModes: [.v6]
)
