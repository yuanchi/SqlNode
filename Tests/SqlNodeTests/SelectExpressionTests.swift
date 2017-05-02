import XCTest
@testable import SqlNode

class SelectExpressionTests: XCTestCase {
  func findFirstOrNew() {
    let se = SelectExpression()
    XCTAssertEqual(0, se.children.count)

    let from1 = se.findFirstOrNew(with: From.self)
    XCTAssertEqual(1, se.children.count)
    XCTAssertTrue((se.children.last as! From) === from1)

    let from2 = se.findFirstOrNew(with: From.self)
    XCTAssertEqual(1, se.children.count)
    XCTAssertTrue(from2 === from1)

    // output sql order is not effected by config order
    _ = se.from("PERSON", as: "p").select("p.name", "p.code")
    let sql = "SELECT p.name, p.code\n"
            + "FROM PERSON as p"
    XCTAssertEqual(sql, se.toSql())
  }
  func select() {
    let se = SelectExpression()
    _ = se.select().t("p.name").as("name").getStart()!
      .from("PERSON", as: "p")
      .as("per") // this alias will be ignored because not used
    let sql = "SELECT p.name as name\n"
      + "FROM PERSON as p"
    XCTAssertEqual(sql, se.toSql())
  }
  func selectTargets() {
    let se = SelectExpression()
    let me = se.select("s.fistname", "s.lastname", "s.address")
    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.select().children.count)

    XCTAssertTrue(se.select().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("s.fistname", (se.select().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.select().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("s.lastname", (se.select().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.select().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("s.address", (se.select().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("SELECT s.fistname, s.lastname, s.address", se.toSql())
  }
  func selectConfig() {
    let se = SelectExpression()
    let me = se.select{
      _ = $0.t("s.fistname").as("fname")
      .t("s.lastname").as("lname")
      .t("s.address").as("addr")
    }
    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.select().children.count)

    XCTAssertTrue(se.select().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("s.fistname", (se.select().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.select().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("s.lastname", (se.select().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.select().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("s.address", (se.select().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("SELECT s.fistname as fname, s.lastname as lname, s.address as addr", se.toSql())
  }
  func fromTargets() {
    let se = SelectExpression()
    let me = se.from("EMPLOYEE", "WORKITEM", "POINT")
    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.from().children.count)

    XCTAssertTrue(se.from().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (se.from().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.from().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("WORKITEM", (se.from().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.from().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("POINT", (se.from().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("FROM EMPLOYEE, WORKITEM, POINT", se.toSql())
  }
  func fromConfig() {
    let se = SelectExpression()
    let me = se.from{
      _ = $0.t("EMPLOYEE").as("e")
        .t("WORKITEM").as("w")
        .t("POINT").as("p")
    }
    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.from().children.count)

    XCTAssertTrue(se.from().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (se.from().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.from().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("WORKITEM", (se.from().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.from().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("POINT", (se.from().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("FROM EMPLOYEE as e, WORKITEM as w, POINT as p", se.toSql())
  }
  func fromAs() {
    let se = SelectExpression()
    let me = se.from("EMPLOYEE", as: "e")
      .from("WORKITEM", as: "w")
      .from("POINT", as: "p")
    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.from().children.count)

    XCTAssertTrue(se.from().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("EMPLOYEE", (se.from().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.from().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("WORKITEM", (se.from().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.from().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("POINT", (se.from().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("FROM EMPLOYEE as e, WORKITEM as w, POINT as p", se.toSql())
  }
  func whereTargets() {
    let se = SelectExpression()
    let me = se.where("p.firstname = 'Richael'", "p.lastname = 'Carson'", "p.address LIKE '%American%'")

    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.where().children.count)

    XCTAssertTrue(se.where().children[0] as? SimpleCondition != nil)
    XCTAssertEqual("p.firstname = 'Richael'", (se.where().children[0] as! SimpleCondition).expression)

    XCTAssertTrue(se.where().children[1] as? SimpleCondition != nil)
    XCTAssertEqual("p.lastname = 'Carson'", (se.where().children[1] as! SimpleCondition).expression)

    XCTAssertTrue(se.where().children[2] as? SimpleCondition != nil)
    XCTAssertEqual("p.address LIKE '%American%'", (se.where().children[2] as! SimpleCondition).expression)

    XCTAssertEqual("WHERE p.firstname = 'Richael' AND p.lastname = 'Carson' AND p.address LIKE '%American%'", se.toSql())
  }
  func whereConfig() {
    let se = SelectExpression()
    let me = se.where{
      _ = $0.and("p.firstname = 'Richael'")
        .and("p.lastname = 'Carson'")
        .and("p.address LIKE '%American%'")
    }

    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.where().children.count)

    XCTAssertTrue(se.where().children[0] as? SimpleCondition != nil)
    XCTAssertEqual("p.firstname = 'Richael'", (se.where().children[0] as! SimpleCondition).expression)

    XCTAssertTrue(se.where().children[1] as? SimpleCondition != nil)
    XCTAssertEqual("p.lastname = 'Carson'", (se.where().children[1] as! SimpleCondition).expression)

    XCTAssertTrue(se.where().children[2] as? SimpleCondition != nil)
    XCTAssertEqual("p.address LIKE '%American%'", (se.where().children[2] as! SimpleCondition).expression)

    XCTAssertEqual("WHERE p.firstname = 'Richael' AND p.lastname = 'Carson' AND p.address LIKE '%American%'", se.toSql())
  }
  func orderByTargets() {
    let se = SelectExpression()
    let me = se.orderBy("p.firstname DESC", "p.lastname ASC", "p.address")

    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.orderBy().children.count)

    XCTAssertTrue(se.orderBy().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("p.firstname DESC", (se.orderBy().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.orderBy().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("p.lastname ASC", (se.orderBy().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.orderBy().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("p.address", (se.orderBy().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("ORDER BY p.firstname DESC, p.lastname ASC, p.address", se.toSql())
  }
  func orderByConfig() {
    let se = SelectExpression()
    let me = se.orderBy{
      _ = $0.t("p.firstname DESC")
        .t("p.lastname ASC")
        .t("p.address")
    }

    XCTAssertTrue(me === se)

    XCTAssertEqual(3, se.orderBy().children.count)

    XCTAssertTrue(se.orderBy().children[0] as? SimpleExpression != nil)
    XCTAssertEqual("p.firstname DESC", (se.orderBy().children[0] as! SimpleExpression).expression)

    XCTAssertTrue(se.orderBy().children[1] as? SimpleExpression != nil)
    XCTAssertEqual("p.lastname ASC", (se.orderBy().children[1] as! SimpleExpression).expression)

    XCTAssertTrue(se.orderBy().children[2] as? SimpleExpression != nil)
    XCTAssertEqual("p.address", (se.orderBy().children[2] as! SimpleExpression).expression)

    XCTAssertEqual("ORDER BY p.firstname DESC, p.lastname ASC, p.address", se.toSql())
  }
  func toSql() {
    let se = SelectExpression()
    _ = se.from("EMPLOYEE", as: "e")
    XCTAssertEqual("FROM EMPLOYEE as e", se.toSql())

    _ = se.select("e.name", "e.code")
    var sql = "SELECT e.name, e.code\n"
      + "FROM EMPLOYEE as e"
    XCTAssertEqual(sql, se.toSql())

    _ = se.where("e.points = 1000", "e.age > 50", "e.salary > 3000")
    sql = "SELECT e.name, e.code\n"
      + "FROM EMPLOYEE as e\n"
      + "WHERE e.points = 1000 AND e.age > 50 AND e.salary > 3000"
    XCTAssertEqual(sql, se.toSql())

    _ = se.orderBy("e.id DESC", "e.age ASC", "e.salary DESC")
    sql = "SELECT e.name, e.code\n"
      + "FROM EMPLOYEE as e\n"
      + "WHERE e.points = 1000 AND e.age > 50 AND e.salary > 3000\n"
      + "ORDER BY e.id DESC, e.age ASC, e.salary DESC"
    XCTAssertEqual(sql, se.toSql())
  }
  func copy() {
    let se = SelectExpression()
    _ = se.select().t("e.firstname").as("fname")
        .t("e.lastname").as("lname")
        .t("e.salary").as("salary").getStart()!
      .from("EMPLOYEE", as: "e")
      .where()
        .and("e.startDate > '2011-11-12'")
        .or{
          _ = $0.and("e.points > 100")
            .and("e.manager LIKE 'Bob'")
        }
    let sql = "SELECT e.firstname as fname, e.lastname as lname, e.salary as salary\n"
      + "FROM EMPLOYEE as e\n"
      + "WHERE e.startDate > '2011-11-12' OR (e.points > 100 AND e.manager LIKE 'Bob')"
    XCTAssertEqual(sql, se.toSql())
    let copy = se.copy()
    XCTAssertEqual(sql, copy.toSql())
  }
  static var allTests = [
      ("findFirstOrNew", findFirstOrNew),
      ("select", select),
      ("selectTargets", selectTargets),
      ("selectConfig", selectConfig),
      ("fromTargets", fromTargets),
      ("fromConfig", fromConfig),
      ("fromAs", fromAs),
      ("whereTargets", whereTargets),
      ("whereConfig", whereConfig),
      ("orderByTargets", orderByTargets),
      ("orderByConfig", orderByConfig),
      ("toSql", toSql),
      ("copy", copy),
  ]
}
