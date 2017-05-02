import XCTest
@testable import SqlNode

class JoinTests: XCTestCase {
  func copy() {
    let join = Join()
    join.type = "LEFT OUTER JOIN"
    let copy = join.copy()
    XCTAssertFalse(join === copy)
    XCTAssertEqual(join.type, copy.type)
  }

  static var allTests = [
    ("copy", copy),
  ]
}
