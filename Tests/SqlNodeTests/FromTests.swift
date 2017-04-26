import XCTest
@testable import SqlNode

class FromTests: XCTestCase {
  func joinTarget() {
    let from = From()
    let me = from.t("COUNTRY").join("EMPLOYEE")
    XCTAssertTrue(me === from)

    XCTAssertEqual(3, from.children.count)

    XCTAssertTrue(from.children[0] as? SimpleExpression != nil)
    XCTAssertEqual("COUNTRY", (from.children[0] as! SimpleExpression).expression)

    XCTAssertTrue(from.children[1] as? Join != nil)
    XCTAssertEqual("JOIN", (from.children[1] as! Join).type)

    XCTAssertTrue(from.children[2] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (from.children[2] as! SimpleExpression).expression)

    let sql = "FROM COUNTRY\n"
      + "JOIN EMPLOYEE"
    XCTAssertEqual(sql, from.toSql())
  }
  func joinSubquery() {
    let from = From()
    let me = from.t("EMPLOYEE")
      .join{
        _ = $0.select("p.points", "p.success", "p.failed")
          .from("POINT", as: "p")
          .where("p.id > 100")
      }
      .as("emp_point")
    XCTAssertTrue(me === from)

    let sql = "FROM EMPLOYEE\n"
      + "JOIN (SELECT p.points, p.success, p.failed\n"
      + "FROM POINT as p\n"
      + "WHERE p.id > 100) as emp_point"
    XCTAssertEqual(sql, from.toSql())
  }
  func innerJoinTarget() {
    let from = From()
    let me = from.t("COUNTRY").innerJoin("EMPLOYEE")
    XCTAssertTrue(me === from)

    XCTAssertEqual(3, from.children.count)

    XCTAssertTrue(from.children[0] as? SimpleExpression != nil)
    XCTAssertEqual("COUNTRY", (from.children[0] as! SimpleExpression).expression)

    XCTAssertTrue(from.children[1] as? Join != nil)
    XCTAssertEqual("INNER JOIN", (from.children[1] as! Join).type)

    XCTAssertTrue(from.children[2] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (from.children[2] as! SimpleExpression).expression)

    let sql = "FROM COUNTRY\n"
      + "INNER JOIN EMPLOYEE"
    XCTAssertEqual(sql, from.toSql())
  }
  func innerJoinSubquery() {
    let from = From()
    let me = from.t("EMPLOYEE")
      .innerJoin{
        _ = $0.select("p.points", "p.success", "p.failed")
          .from("POINT", as: "p")
          .where("p.id > 100")
      }
      .as("emp_point")
    XCTAssertTrue(me === from)

    let sql = "FROM EMPLOYEE\n"
      + "INNER JOIN (SELECT p.points, p.success, p.failed\n"
      + "FROM POINT as p\n"
      + "WHERE p.id > 100) as emp_point"
    XCTAssertEqual(sql, from.toSql())
  }
  func leftOuterJoinTarget() {
    let from = From()
    let me = from.t("COUNTRY").leftOuterJoin("EMPLOYEE")
    XCTAssertTrue(me === from)

    XCTAssertEqual(3, from.children.count)

    XCTAssertTrue(from.children[0] as? SimpleExpression != nil)
    XCTAssertEqual("COUNTRY", (from.children[0] as! SimpleExpression).expression)

    XCTAssertTrue(from.children[1] as? Join != nil)
    XCTAssertEqual("LEFT OUTER JOIN", (from.children[1] as! Join).type)

    XCTAssertTrue(from.children[2] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (from.children[2] as! SimpleExpression).expression)

    let sql = "FROM COUNTRY\n"
      + "LEFT OUTER JOIN EMPLOYEE"
    XCTAssertEqual(sql, from.toSql())
  }
  func leftOuterJoinSubquery() {
    let from = From()
    let me = from.t("EMPLOYEE")
      .leftOuterJoin{
        _ = $0.select("p.points", "p.success", "p.failed")
          .from("POINT", as: "p")
          .where("p.id > 100")
      }
      .as("emp_point")
    XCTAssertTrue(me === from)

    let sql = "FROM EMPLOYEE\n"
      + "LEFT OUTER JOIN (SELECT p.points, p.success, p.failed\n"
      + "FROM POINT as p\n"
      + "WHERE p.id > 100) as emp_point"
    XCTAssertEqual(sql, from.toSql())
  }
  func rightOuterJoinTarget() {
    let from = From()
    let me = from.t("COUNTRY").rightOuterJoin("EMPLOYEE")
    XCTAssertTrue(me === from)

    XCTAssertEqual(3, from.children.count)

    XCTAssertTrue(from.children[0] as? SimpleExpression != nil)
    XCTAssertEqual("COUNTRY", (from.children[0] as! SimpleExpression).expression)

    XCTAssertTrue(from.children[1] as? Join != nil)
    XCTAssertEqual("RIGHT OUTER JOIN", (from.children[1] as! Join).type)

    XCTAssertTrue(from.children[2] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (from.children[2] as! SimpleExpression).expression)

    let sql = "FROM COUNTRY\n"
      + "RIGHT OUTER JOIN EMPLOYEE"
    XCTAssertEqual(sql, from.toSql())
  }
  func rightOuterJoinSubquery() {
    let from = From()
    let me = from.t("EMPLOYEE")
      .rightOuterJoin{
        _ = $0.select("p.points", "p.success", "p.failed")
          .from("POINT", as: "p")
          .where("p.id > 100")
      }
      .as("emp_point")
    XCTAssertTrue(me === from)

    let sql = "FROM EMPLOYEE\n"
      + "RIGHT OUTER JOIN (SELECT p.points, p.success, p.failed\n"
      + "FROM POINT as p\n"
      + "WHERE p.id > 100) as emp_point"
    XCTAssertEqual(sql, from.toSql())
  }
  func crossJoinTarget() {
    let from = From()
    let me = from.t("COUNTRY").crossJoin("EMPLOYEE")
    XCTAssertTrue(me === from)

    XCTAssertEqual(3, from.children.count)

    XCTAssertTrue(from.children[0] as? SimpleExpression != nil)
    XCTAssertEqual("COUNTRY", (from.children[0] as! SimpleExpression).expression)

    XCTAssertTrue(from.children[1] as? Join != nil)
    XCTAssertEqual("CROSS JOIN", (from.children[1] as! Join).type)

    XCTAssertTrue(from.children[2] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (from.children[2] as! SimpleExpression).expression)

    let sql = "FROM COUNTRY\n"
      + "CROSS JOIN EMPLOYEE"
    XCTAssertEqual(sql, from.toSql())
  }
  func crossJoinSubquery() {
    let from = From()
    let me = from.t("EMPLOYEE")
      .crossJoin{
        _ = $0.select("p.points", "p.success", "p.failed")
          .from("POINT", as: "p")
          .where("p.id > 100")
      }
      .as("emp_point")
    XCTAssertTrue(me === from)

    let sql = "FROM EMPLOYEE\n"
      + "CROSS JOIN (SELECT p.points, p.success, p.failed\n"
      + "FROM POINT as p\n"
      + "WHERE p.id > 100) as emp_point"
    XCTAssertEqual(sql, from.toSql())
  }
  func on() {
    let from = From()
    let me = from.t("EMPLOYEE").as("emp")
      .leftOuterJoin("SALARY").as("sal")
      .on("emp.id = sal.emp_id")
      .leftOuterJoin{
        _ = $0.select{
          _ = $0.t("p.points").as("point")
            .t("p.success").as("suc")
            .t("p.failed").as("fail")
            .t("p.emp_id").as("eid")
          }
          .from("POINT", as: "p")
          .where("p.id > 100")
      }
      .as("emp_point")
      .on("emp.id = emp_point.eid")
    XCTAssertTrue(me === from)

    let sql = "FROM EMPLOYEE as emp\n"
      + "LEFT OUTER JOIN SALARY as sal\n"
      + "ON emp.id = sal.emp_id\n"
      + "LEFT OUTER JOIN (SELECT p.points as point, p.success as suc, p.failed as fail, p.emp_id as eid\n"
      + "FROM POINT as p\n"
      + "WHERE p.id > 100) as emp_point\n"
      + "ON emp.id = emp_point.eid"
    XCTAssertEqual(sql, from.toSql())
  }
  static var allTests = [
    ("joinTarget", joinTarget),
    ("joinSubquery", joinSubquery),
    ("innerJoinTarget", innerJoinTarget),
    ("innerJoinSubquery", innerJoinSubquery),
    ("leftOuterJoinTarget", leftOuterJoinTarget),
    ("leftOuterJoinSubquery", leftOuterJoinSubquery),
    ("rightOuterJoinTarget", rightOuterJoinTarget),
    ("rightOuterJoinSubquery", rightOuterJoinSubquery),
    ("crossJoinTarget", crossJoinTarget),
    ("crossJoinSubquery", crossJoinSubquery),
    ("on", on)
  ]
}
