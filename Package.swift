// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SqlNode",
    dependencies: [
      .Package(url: "https://github.com/yuanchi/TreeNode.git", majorVersion: 1)
    ]
)
