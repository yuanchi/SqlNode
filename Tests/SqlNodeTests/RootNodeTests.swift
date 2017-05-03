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

  static var allTests = [
      ("initialize", initialize),
      ("paramVals", paramVals),
  ]
}
