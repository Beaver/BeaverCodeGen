// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Commander",
  products: [
    .library(name: "BeaverCodeGen", targets: ["BeaverCodeGen"]),
  ],
  dependencies: [
    .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.18.1")
  ]
)