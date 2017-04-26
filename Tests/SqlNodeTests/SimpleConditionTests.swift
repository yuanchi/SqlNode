import XCTest
@testable import SqlNode

class SimpleConditionTests: XCTestCase {
  func toSql() {
    let sc = SimpleCondition()
    sc.expression = "p.guid = 'uier009'"
    XCTAssertEqual("AND p.guid = 'uier009'", sc.toSql())

    sc.junction = .OR
    XCTAssertEqual("OR p.guid = 'uier009'", sc.toSql())
  }
  static var allTests = [
      ("toSql", toSql)
  ]
}
