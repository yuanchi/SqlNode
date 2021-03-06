import XCTest
@testable import SqlNode

class SimpleExpressionTests: XCTestCase {

  func aliasGetterSetter() {
    let se = SimpleExpression()
    let alias = "EMPLOYEE"
    _ = se.`as`(alias)
    XCTAssertEqual(alias, se.alias)
  }
  func toSql() {
    let se = SimpleExpression()
    se.expression = "p.name"
    XCTAssertEqual("p.name", se.toSql())

    se.alias = "p_Name"
    XCTAssertEqual("p.name as p_Name", se.toSql())

    se.expression = "EMPLOYEE"
    se.alias = "e"
    XCTAssertEqual("EMPLOYEE as e", se.toSql())
  }
  func copy() {
    let se = SimpleExpression()
    se.expression = "EMPLOYEE"
    _ = se.as("e")
    let copy = se.copy()

    XCTAssertFalse(se === copy)
    XCTAssertEqual("EMPLOYEE", copy.expression)
    XCTAssertEqual("e", copy.alias)
    XCTAssertEqual(se.toSql(), copy.toSql())
  }

  static var allTests = [
      ("aliasGetterSetter", aliasGetterSetter),
      ("toSql", toSql),
      ("copy", copy),
  ]
}
