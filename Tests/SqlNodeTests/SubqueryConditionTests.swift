import XCTest
@testable import SqlNode

class SubqueryConditionTests: XCTestCase {
  func copy() {
      let sc = SubqueryCondition()
      sc.prefix = "p.id IN"
      _ = sc.subquery()
        .select("a.id")
        .from("ACCOUNT", as: "a")
        .where("a.start > '2011-12-31'")
        .as("acc")

      let sql = "p.id IN (SELECT a.id\n"
        + "FROM ACCOUNT as a\n"
        + "WHERE a.start > '2011-12-31') as acc"
      XCTAssertEqual(sql, sc.toSql())

      let copy = sc.copy()
      XCTAssertFalse(sc === copy)
      XCTAssertEqual("p.id IN", copy.prefix)
      XCTAssertEqual(sql, copy.toSql())
  }

  static var allTests = [
      ("copy", copy),
  ]
}
