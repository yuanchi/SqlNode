import XCTest
@testable import SqlNode

class RootNodeTests: XCTestCase {
  func initialize() {
    _ = RootNode.initialize()
      .config{_ = ($0 as! RootNode)
        .factory!
        .add(with: TestNode.self, { TestNode() })
        .replace(with: From.self, { From() })}
  }


  static var allTests = [
      ("initialize", initialize),
  ]
}
