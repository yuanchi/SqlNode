import XCTest
@testable import SqlNode

class FromTests: XCTestCase {
  func joinTarget() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .join("ACCOUNT").as("a")
      .on("e.id = a.emp_id")

    let sql = "FROM EMPLOYEE as e\n"
      + "JOIN ACCOUNT as a\n"
      + " ON e.id = a.emp_id"
    XCTAssertEqual(sql, from.toSql())
  }
  func joinSubquery() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .join {
        _ = $0.select().t("a.emp_id").as("eid")
            .t("a.balance").as("balc")
            .t("a.startDate").as("start").getStart()!
          .from("ACCOUNT", as: "a")
      }.as("acc")
      .on("e.id = acc.eid")
    let sql = "FROM EMPLOYEE as e\n"
            + "JOIN (SELECT a.emp_id as eid, a.balance as balc, a.startDate as start\n"
            + "FROM ACCOUNT as a) as acc\n"
            + " ON e.id = acc.eid"
    XCTAssertEqual(sql, from.toSql())
  }
  func innerJoinTarget() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .innerJoin("ACCOUNT").as("a")
      .on("e.id = a.emp_id")

    let sql = "FROM EMPLOYEE as e\n"
      + "INNER JOIN ACCOUNT as a\n"
      + " ON e.id = a.emp_id"
    XCTAssertEqual(sql, from.toSql())
  }
  func innerJoinSubquery() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .innerJoin {
        _ = $0.select().t("a.emp_id").as("eid")
            .t("a.balance").as("balc")
            .t("a.startDate").as("start").getStart()!
          .from("ACCOUNT", as: "a")
      }.as("acc")
      .on("e.id = acc.eid")
    let sql = "FROM EMPLOYEE as e\n"
            + "INNER JOIN (SELECT a.emp_id as eid, a.balance as balc, a.startDate as start\n"
            + "FROM ACCOUNT as a) as acc\n"
            + " ON e.id = acc.eid"
    XCTAssertEqual(sql, from.toSql())
  }
  func leftOuterJoinTarget() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .leftOuterJoin("ACCOUNT").as("a")
      .on("e.id = a.emp_id")

    let sql = "FROM EMPLOYEE as e\n"
      + "LEFT OUTER JOIN ACCOUNT as a\n"
      + " ON e.id = a.emp_id"
    XCTAssertEqual(sql, from.toSql())
  }
  func leftOuterJoinSubquery() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .leftOuterJoin {
        _ = $0.select().t("a.emp_id").as("eid")
            .t("a.balance").as("balc")
            .t("a.startDate").as("start").getStart()!
          .from("ACCOUNT", as: "a")
      }.as("acc")
      .on("e.id = acc.eid")
    let sql = "FROM EMPLOYEE as e\n"
            + "LEFT OUTER JOIN (SELECT a.emp_id as eid, a.balance as balc, a.startDate as start\n"
            + "FROM ACCOUNT as a) as acc\n"
            + " ON e.id = acc.eid"
    XCTAssertEqual(sql, from.toSql())
  }
  func rightOuterJoinTarget() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .rightOuterJoin("ACCOUNT").as("a")
      .on("e.id = a.emp_id")

    let sql = "FROM EMPLOYEE as e\n"
      + "RIGHT OUTER JOIN ACCOUNT as a\n"
      + " ON e.id = a.emp_id"
    XCTAssertEqual(sql, from.toSql())
  }
  func rightOuterJoinSubquery() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .rightOuterJoin {
        _ = $0.select().t("a.emp_id").as("eid")
            .t("a.balance").as("balc")
            .t("a.startDate").as("start").getStart()!
          .from("ACCOUNT", as: "a")
      }.as("acc")
      .on("e.id = acc.eid")
    let sql = "FROM EMPLOYEE as e\n"
            + "RIGHT OUTER JOIN (SELECT a.emp_id as eid, a.balance as balc, a.startDate as start\n"
            + "FROM ACCOUNT as a) as acc\n"
            + " ON e.id = acc.eid"
    XCTAssertEqual(sql, from.toSql())
  }
  func crossJoinTarget() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .crossJoin("ACCOUNT").as("a")
      .on("e.id = a.emp_id")

    let sql = "FROM EMPLOYEE as e\n"
      + "CROSS JOIN ACCOUNT as a\n"
      + " ON e.id = a.emp_id"
    XCTAssertEqual(sql, from.toSql())
  }
  func crossJoinSubquery() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .crossJoin {
        _ = $0.select().t("a.emp_id").as("eid")
            .t("a.balance").as("balc")
            .t("a.startDate").as("start").getStart()!
          .from("ACCOUNT", as: "a")
      }.as("acc")
      .on("e.id = acc.eid")
    let sql = "FROM EMPLOYEE as e\n"
            + "CROSS JOIN (SELECT a.emp_id as eid, a.balance as balc, a.startDate as start\n"
            + "FROM ACCOUNT as a) as acc\n"
            + " ON e.id = acc.eid"
    XCTAssertEqual(sql, from.toSql())
  }
  func onMultiConditions() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .crossJoin("ACCOUNT").as("a")
      .on("e.firstname = a.firstname", "e.lastname = a.lastname")

    let sql = "FROM EMPLOYEE as e\n"
      + "CROSS JOIN ACCOUNT as a\n"
      + " ON e.firstname = a.firstname AND e.lastname = a.lastname"
    XCTAssertEqual(sql, from.toSql())
  }
  func copy() {
    let from = From()
    _ = from.t("EMPLOYEE").as("e")
      .crossJoin {
        _ = $0.select().t("a.emp_id").as("eid")
            .t("a.balance").as("balc")
            .t("a.startDate").as("start").getStart()!
          .from("ACCOUNT", as: "a")
      }.as("acc")
      .on("e.id = acc.eid")
      
    let copy = from.copy()
    XCTAssertEqual(from.toSql(), copy.toSql())
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
    ("onMultiConditions", onMultiConditions),
    ("copy", copy),
  ]
}
