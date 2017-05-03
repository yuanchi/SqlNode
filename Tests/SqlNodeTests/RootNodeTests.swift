import XCTest
@testable import SqlNode

class RootNodeTests: XCTestCase {
  func initialize() {
    _ = RootNode.initialize()
      .config{_ = ($0 as! RootNode)
        .factory!
        .add(with: TestNode.self, { TestNode() })
        .replace(with: From.self, { From() })}
  }
  func paramVals() {
    let root = RootNode.initialize()
      .select("e.id", "e.firstname", "e.lastname")
      .from("EMPLOYEE", as: "e")
      .where {
        _ = $0.and("e.salary > ?").paramVal(3000)
          .or {
            _ = $0.and("e.startDate > ?").paramVal("2011-09-12")
              .and("e.endDate < ?").paramVal("2015-10-11")
          }
      }
      .orderBy("e.salary DESC")

    let extra = ParameterizableExpression("LIMIT ? OFFSET ?")
    _ = extra.addParamVal(10).addParamVal(1)
    _ = root.add(child: extra)

    let sql = "SELECT e.id, e.firstname, e.lastname\n"
      + "FROM EMPLOYEE as e\n"
      + "WHERE e.salary > ? OR (e.startDate > ? AND e.endDate < ?)\n"
      + "ORDER BY e.salary DESC\n"
      + "LIMIT ? OFFSET ?"
    XCTAssertEqual(sql, root.toSql())

    var paramVals = root.paramVals()
    XCTAssertEqual(5, paramVals.count)
    XCTAssertEqual(3000, paramVals[0] as! Int)
    XCTAssertEqual("2011-09-12", paramVals[1] as! String)
    XCTAssertEqual("2015-10-11", paramVals[2] as! String)
    XCTAssertEqual(10, paramVals[3] as! Int)
    XCTAssertEqual(1, paramVals[4] as! Int)

    let f = root[.expression("e.endDate < ?")]
    (f as! SimpleCondition).paramVal = nil

    paramVals = root.paramVals()
    XCTAssertEqual(4, paramVals.count)
    XCTAssertEqual(3000, paramVals[0] as! Int)
    XCTAssertEqual("2011-09-12", paramVals[1] as! String)
    XCTAssertEqual(10, paramVals[2] as! Int)
    XCTAssertEqual(1, paramVals[3] as! Int)
  }
  func paging() {
    let root = RootNode.initialize()
      .select("a.id", "a.name")
      .from("ACCOUNT", as: "a")
      .where {
        _ = $0.and("a.open > ?")
          .or("a.open < ?")
      }
      .orderBy("a.name")

    let pn = PageNavigator(totalCount: 13, countPerPage: 3)
    pn.currentPage = 3

    root.pageNavigator = pn

    let paging = root.paging()
    let sql = "SELECT a.id, a.name\n"
      + "FROM ACCOUNT as a\n"
      + "WHERE a.open > ? OR a.open < ?\n"
      + "ORDER BY a.name\n"
      + "LIMIT 3 OFFSET 6"
    XCTAssertEqual(sql, paging.toSql())
  }
  func oraclePaging() {
    let root = RootNode.initialize()
      .select("a.id", "a.name")
      .from("ACCOUNT", as: "a")
      .where {
        _ = $0.and("a.open > ?")
          .or("a.open < ?")
      }
      .orderBy("a.name")

    let paging = RootNode.initialize()
    _ = paging.select("*")
      .from { _ = $0.subquery()
          .select { _ = $0.t("tmp.*").t("rownum").as("rn") }
          .from()
            .add(child: root.copy()) // add root copy as child node
            .as("tmp").getStart()!
          .where("rownum <= 20")
      }
      .where("rn > 10")

    let sql = "SELECT *\n"
      + "FROM (SELECT tmp.*, rownum as rn\n"
      +   "FROM (SELECT a.id, a.name\n"
      +     "FROM ACCOUNT as a\n"
      +     "WHERE a.open > ? OR a.open < ?\n"
      +     "ORDER BY a.name) as tmp\n"
      +   "WHERE rownum <= 20)\n"
      + "WHERE rn > 10"
    XCTAssertEqual(sql, paging.toSql())
  }

  static var allTests = [
      ("initialize", initialize),
      ("paramVals", paramVals),
      ("paging", paging),
      ("oraclePaging", oraclePaging),
  ]
}
