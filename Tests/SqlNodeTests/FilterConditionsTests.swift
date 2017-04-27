import XCTest
@testable import SqlNode

class FilterConditionsTests: XCTestCase {
  func andSingleCondition() {
    let fc = FilterConditions()
    let me = fc.and("e.id > 1000")
    XCTAssertTrue(fc === me)
    XCTAssertTrue((fc.children[0] as? SimpleCondition) != nil)
    XCTAssertEqual("e.id > 1000", (fc.children[0] as! SimpleCondition).expression)
    XCTAssertEqual("AND e.id > 1000", fc.toSql())

    _ = fc.and("e.age < 50")
    XCTAssertTrue((fc.children[1] as? SimpleCondition) != nil)
    XCTAssertEqual("e.age < 50", (fc.children[1] as! SimpleCondition).expression)
    XCTAssertEqual("AND (e.id > 1000 AND e.age < 50)", fc.toSql())
  }
  func orSingleCondition() {
    let fc = FilterConditions()
    let me = fc.and("e.id > 1000") // with or function, the result is the same
    XCTAssertTrue(fc === me)
    XCTAssertTrue((fc.children[0] as? SimpleCondition) != nil)
    XCTAssertEqual("e.id > 1000", (fc.children[0] as! SimpleCondition).expression)
    XCTAssertEqual("AND e.id > 1000", fc.toSql())

    _ = fc.or("e.age < 50")
    XCTAssertTrue((fc.children[1] as? SimpleCondition) != nil)
    XCTAssertEqual("e.age < 50", (fc.children[1] as! SimpleCondition).expression)
    XCTAssertEqual("AND (e.id > 1000 OR e.age < 50)", fc.toSql())
  }
  func andMultiConditions() {
    let fc = FilterConditions()
    let me = fc.and{
      _ = $0.and("e.id > 1000")
    }
    XCTAssertTrue(fc === me)
    XCTAssertEqual("AND e.id > 1000", fc.toSql())

    fc.children.removeAll()
    _ = fc.and{
      _ = $0.and("e.id > 1000")
        .and("e.age < 50")
    }
    XCTAssertEqual("AND (e.id > 1000 AND e.age < 50)", fc.toSql())

    fc.children.removeAll()
    _ = fc.and("e.gender = 0")
      .and{
        _ = $0.and("e.id > 1000")
          .and("e.age < 50")
      }
    XCTAssertEqual("AND (e.gender = 0 AND (e.id > 1000 AND e.age < 50))", fc.toSql())
  }
  func orMultiConditions() {
    let fc = FilterConditions()
    let me = fc.and{
      _ = $0.and("e.id > 1000")
    }
    XCTAssertTrue(fc === me)
    XCTAssertEqual("AND e.id > 1000", fc.toSql())

    fc.children.removeAll()
    _ = fc.and{
      _ = $0.and("e.id > 1000")
        .or("e.age < 50")
    }
    XCTAssertEqual("AND (e.id > 1000 OR e.age < 50)", fc.toSql())

    fc.children.removeAll()
    _ = fc.and("e.gender = 0")
      .or{
        _ = $0.and("e.id > 1000")
          .or("e.age < 50")
      }
    XCTAssertEqual("AND (e.gender = 0 OR (e.id > 1000 OR e.age < 50))", fc.toSql())
  }
  func andSubqueryCondition() {
    let fc = FilterConditions()
    let me = fc.and("p.id IN", {
      _ = $0.select().t("a.id").as("id").getStart()!
        .from("account", as: "a")
        .where("a.balance < 10000")
    })
    XCTAssertTrue(fc === me)

    var sql = "AND p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000)"
    XCTAssertEqual(sql, fc.toSql())

    _ = fc.and("p.success = 1")
    sql = "AND (p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000) AND p.success = 1)"
    XCTAssertEqual(sql, fc.toSql())
  }
  func orSubqueryCondition() {
    let fc = FilterConditions()
    let me = fc.and("p.id IN", {
      _ = $0.select().t("a.id").as("id").getStart()!
        .from("account", as: "a")
        .where("a.balance < 10000")
    })
    XCTAssertTrue(fc === me)

    var sql = "AND p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000)"
    XCTAssertEqual(sql, fc.toSql())

    _ = fc.or("p.success = 1")
    sql = "AND (p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000) OR p.success = 1)"
    XCTAssertEqual(sql, fc.toSql())
  }
  static var allTests = [
    ("andSingleCondition", andSingleCondition),
    ("orSingleCondition", orSingleCondition),
    ("andMultiConditions", andMultiConditions),
    ("orMultiConditions", orMultiConditions),
    ("andSubqueryCondition", andSubqueryCondition),
    ("orSubqueryCondition", orSubqueryCondition),
  ]
}
