import XCTest
@testable import SqlNode

class SimpleConditionTests: XCTestCase {
  func toSql() {
    let sc = SimpleCondition()
    sc.expression = "p.guid = 'uier009'"
    XCTAssertEqual("p.guid = 'uier009'", sc.toSql())

    sc.junction = .OR
    XCTAssertEqual("p.guid = 'uier009'", sc.toSql())
  }
  static var allTests = [
      ("toSql", toSql)
  ]
}
