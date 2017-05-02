import XCTest
@testable import SqlNode

class FilterConditionsTests: XCTestCase {
  func andSingleCondition() {
    let fc = FilterConditions()
    let me = fc.and("e.id > 1000")
    XCTAssertTrue(fc === me)
    XCTAssertTrue((fc.children[0] as? SimpleCondition) != nil)
    XCTAssertEqual("e.id > 1000", (fc.children[0] as! SimpleCondition).expression)
    XCTAssertEqual("e.id > 1000", fc.toSql())

    _ = fc.and("e.age < 50")
    XCTAssertTrue((fc.children[1] as? SimpleCondition) != nil)
    XCTAssertEqual("e.age < 50", (fc.children[1] as! SimpleCondition).expression)
    XCTAssertEqual("e.id > 1000 AND e.age < 50", fc.toSql())
  }
  func orSingleCondition() {
    let fc = FilterConditions()
    let me = fc.and("e.id > 1000") // with or function, the result is the same
    XCTAssertTrue(fc === me)
    XCTAssertTrue((fc.children[0] as? SimpleCondition) != nil)
    XCTAssertEqual("e.id > 1000", (fc.children[0] as! SimpleCondition).expression)
    XCTAssertEqual("e.id > 1000", fc.toSql())

    _ = fc.or("e.age < 50")
    XCTAssertTrue((fc.children[1] as? SimpleCondition) != nil)
    XCTAssertEqual("e.age < 50", (fc.children[1] as! SimpleCondition).expression)
    XCTAssertEqual("e.id > 1000 OR e.age < 50", fc.toSql())
  }
  func andMultiConditions() {
    let fc = FilterConditions()
    let me = fc.and{
      _ = $0.and("e.id > 1000")
    }
    XCTAssertTrue(fc === me)
    XCTAssertEqual("e.id > 1000", fc.toSql())

    fc.children.removeAll()
    _ = fc.and{
      _ = $0.and("e.id > 1000")
        .and("e.age < 50")
    }
    XCTAssertEqual("(e.id > 1000 AND e.age < 50)", fc.toSql())

    fc.children.removeAll()
    _ = fc.and("e.gender = 0")
      .and{
        _ = $0.and("e.id > 1000")
          .and("e.age < 50")
      }
    XCTAssertEqual("e.gender = 0 AND (e.id > 1000 AND e.age < 50)", fc.toSql())
  }
  func orMultiConditions() {
    let fc = FilterConditions()
    let me = fc.and{
      _ = $0.and("e.id > 1000")
    }
    XCTAssertTrue(fc === me)
    XCTAssertEqual("e.id > 1000", fc.toSql())

    fc.children.removeAll()
    _ = fc.and{
      _ = $0.and("e.id > 1000")
        .or("e.age < 50")
    }
    XCTAssertEqual("(e.id > 1000 OR e.age < 50)", fc.toSql())

    fc.children.removeAll()
    _ = fc.and("e.gender = 0")
      .or{
        _ = $0.and("e.id > 1000")
          .or("e.age < 50")
      }
    XCTAssertEqual("e.gender = 0 OR (e.id > 1000 OR e.age < 50)", fc.toSql())
  }
  func andSubqueryCondition() {
    let fc = FilterConditions()
    let me = fc.and("p.id IN", {
      _ = $0.select().t("a.id").as("id").getStart()!
        .from("account", as: "a")
        .where("a.balance < 10000")
    })
    XCTAssertTrue(fc === me)

    var sql = "p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000)"
    XCTAssertEqual(sql, fc.toSql())

    _ = fc.and("p.success = 1")
    sql = "p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000) AND p.success = 1"
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

    var sql = "p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000)"
    XCTAssertEqual(sql, fc.toSql())

    _ = fc.or("p.success = 1")
    sql = "p.id IN (SELECT a.id as id\n"
      + "FROM account as a\n"
      + "WHERE a.balance < 10000) OR p.success = 1"
    XCTAssertEqual(sql, fc.toSql())
  }
  func lcVal() {
    let fc = FilterConditions()
    let me = fc.and("p.name = :pname").paramVal("Bob")
    XCTAssertTrue(fc === me)
    XCTAssertEqual("Bob", (fc.children.last as! SimpleCondition).paramVal as? String)

    _ = fc.and("p.age < :page").paramVal(33)
    XCTAssertEqual(33, (fc.children.last as! SimpleCondition).paramVal as? Int)
  }
  func removeConditionsWithParamValNil() {
    let fc = FilterConditions()
    _ = fc.and("e.firstname LIKE :fname").paramVal("Rachel")
      .and("e.lastname LIKE :lname").paramVal("Carson")
      .and("e.age > :age")
      .or{
        _ = $0.and("e.salary > :salary")
          .and("e.manager = :manager").paramVal("Bob")
      }
    var sql = "e.firstname LIKE :fname AND e.lastname LIKE :lname AND e.age > :age OR (e.salary > :salary AND e.manager = :manager)"
    XCTAssertEqual(sql, fc.toSql())

    _ = fc.removeConditionsWithParamValNil()
    sql = "e.firstname LIKE :fname AND e.lastname LIKE :lname OR e.manager = :manager"
    XCTAssertEqual(sql, fc.toSql())

    let f1 = fc[.expression("e.age > :age")]
    XCTAssertTrue( f1 == nil )

    let f2 = fc[.expression("e.salary > :salary")]
    XCTAssertTrue( f2 == nil )

    let f3 = fc[.expression("e.lastname LIKE :lname")]
    XCTAssertFalse( f3 == nil )
  }
  func condParamVals() {
    let fc = FilterConditions()
    _ = fc.and("e.firstname LIKE :fname").paramVal("Rachel")
      .and("e.lastname LIKE :lname").paramVal("Carson")
      .and("e.age > :age")
      .or{
        _ = $0.and("e.salary > :salary").paramVal(2000)
          .and("e.manager = :manager")
      }
    let paramVals = fc.condParamVals()
    XCTAssertEqual(3, paramVals.count)

    XCTAssertTrue(paramVals[0] as? String != nil)
    XCTAssertEqual("Rachel", paramVals[0] as! String)

    XCTAssertTrue(paramVals[1] as? String != nil)
    XCTAssertEqual("Carson", paramVals[1] as! String)

    XCTAssertTrue(paramVals[2] as? Int != nil)
    XCTAssertEqual(2000, paramVals[2] as! Int)
  }
  func namedParamVals() {
    let fc = FilterConditions()
    _ = fc.and("e.firstname LIKE :fname").paramVal("Rachel")
      .and("e.lastname LIKE :lname").paramVal("Carson")
      .and("e.age > :age")
      .or{
        _ = $0.and("e.salary > :salary").paramVal(2000)
          .and("e.manager = :manager")
      }
    let paramVals = fc.namedParamVals()
    XCTAssertEqual(3, paramVals.count)

    XCTAssertEqual(paramVals["fname"] as! String, "Rachel")
    XCTAssertEqual(paramVals["lname"] as! String, "Carson")
    XCTAssertEqual(paramVals["salary"] as! Int, 2000)
  }
  static var allTests = [
    ("andSingleCondition", andSingleCondition),
    ("orSingleCondition", orSingleCondition),
    ("andMultiConditions", andMultiConditions),
    ("orMultiConditions", orMultiConditions),
    ("andSubqueryCondition", andSubqueryCondition),
    ("orSubqueryCondition", orSubqueryCondition),
    ("lcVal", lcVal),
    ("removeConditionsWithParamValNil", removeConditionsWithParamValNil),
    ("condParamVals", condParamVals),
    ("namedParamVals", namedParamVals),
  ]
}
