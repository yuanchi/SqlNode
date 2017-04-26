import XCTest
@testable import SqlNode

class TargetExpressibleTests: XCTestCase {
  func addTarget() {
    let te = TargetExpressible()
    _ = te.t("p.gender")
    XCTAssertEqual("p.gender", te.toSql())

    _ = te.t("p.code")
    XCTAssertEqual("p.gender, p.code", te.toSql())

    _ = te.t("p.grade")
    XCTAssertEqual("p.gender, p.code, p.grade", te.toSql())
  }
  func `as`() {
    let te = TargetExpressible()
    _ = te.t("EMPLOYEE")
      .as("e")
    XCTAssertEqual("EMPLOYEE as e", te.toSql())

    _ = te.t("PERSON")
      .as("p")
    XCTAssertEqual("EMPLOYEE as e, PERSON as p", te.toSql())
  }
  func subquery() {
    let te = TargetExpressible()
    XCTAssertEqual(0, te.children.count)

    let se: SqlNode = te.subquery()
    XCTAssertEqual(1, te.children.count)
    XCTAssertTrue(te.children.first! is SelectExpression)
    XCTAssertTrue(se is SelectExpression)
  }
  func subqueryWith() {
    let te = TargetExpressible()
    XCTAssertEqual(0, te.children.count)

    let sameObj = te.subquery{ se in
      se.alias = "This is SelectExpression to change its status"
    }
    XCTAssertEqual(1, te.children.count)
    XCTAssertTrue(te.children.first! is SelectExpression)
    XCTAssertEqual(
      "This is SelectExpression to change its status",
      (te.children.first as! SelectExpression).alias)
    XCTAssertTrue(sameObj === te)
  }
  func toSql() {
    let te = TargetExpressible()
    _ = te.t("p.name")
    XCTAssertEqual("p.name", te.toSql())

    _ = te.t("p.code").`as`("code")
    XCTAssertEqual("p.name, p.code as code", te.toSql())

    _ = te.subquery{ se in
      _ = se.select("a.id")
        .from("ACCOUNT", as: "a")
    }.`as`("acc_id")

    var sql = "p.name,\n"
      + "p.code as code,\n"
      + "(SELECT a.id\n"
      + "FROM ACCOUNT as a) as acc_id"
    XCTAssertEqual(sql, te.toSql())

    _ = te.subquery{ se in
      _ = se.select("b.amount")
        .from("BALANCE", as: "b")
    }.`as`("balac_amount")

    sql = "p.name,\n"
      + "p.code as code,\n"
      + "(SELECT a.id\n"
      + "FROM ACCOUNT as a) as acc_id,\n"
      + "(SELECT b.amount\n"
      + "FROM BALANCE as b) as balac_amount"
    XCTAssertEqual(sql, te.toSql())
  }
  static var allTests = [
      ("addTarget", addTarget),
      ("as", `as`),
      ("subquery", subquery),
      ("subqueryWith", subqueryWith),
      ("toSql", toSql)
  ]
}
