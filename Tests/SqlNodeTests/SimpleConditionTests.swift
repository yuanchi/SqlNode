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
  func copy() {
    let sc = SimpleCondition()
    sc.junction = .OR
    sc.expression = "p.name = :name"
    sc.paramVal = "Bob"
    let copy = sc.copy()

    XCTAssertFalse(copy === sc)
    XCTAssertEqual(Junction.OR, copy.junction)
    XCTAssertEqual("p.name = :name", copy.expression)
    XCTAssertTrue(sc.param === copy.param)
    XCTAssertEqual("Bob", copy.paramVal as! String)
    XCTAssertEqual(sc.toSql(), copy.toSql())
  }
  static var allTests = [
      ("toSql", toSql),
      ("copy", copy),
  ]
}
