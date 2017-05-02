import XCTest
@testable import SqlNode

class SqlNodeTests: XCTestCase {
    func create() {
        let root = RootNode.initialize()
        let child = Select()
        _ = root.add(child: child)
        let w: AnyObject = child.create(with: Where.self)
        XCTAssertTrue(w is Where)
    }
    func root() {
      let node1 = SqlNode()
      XCTAssertTrue(node1.root == nil)

      let node2 = RootNode()
      XCTAssertFalse(node2.root == nil)
      XCTAssertTrue(node2.root === node2)

      let node3 = SqlNode()
      let node4 = RootNode()
      _ = node3.add(child: node4)
      XCTAssertTrue(node4.root == nil)
      XCTAssertTrue(node3.root == nil)

      let node5 = RootNode()
      let node6 = SqlNode()
      _ = node5.add(child: node6)
      XCTAssertFalse(node5.root == nil)
      XCTAssertFalse(node6.root == nil)
      XCTAssertTrue(node5.root === node5)
      XCTAssertTrue(node6.root === node5)
    }
    func topMost() {
      let root = SqlNode()
      let n1 = SqlNode()
      let n2 = SqlNode()
      let n1_1 = SqlNode()
      let n1_2 = SqlNode()
      let n2_1 = SqlNode()
      let n2_2 = SqlNode()
      let n1_2_1 = SqlNode()

      _ = n1_2.add(child: n1_2_1)
      XCTAssertTrue(n1_2_1.topMost() === n1_2)
      XCTAssertFalse(n1_2_1.topMost() === root)

      _ = n1.add(children: n1_1, n1_2)
      _ = n2.add(children: n2_1, n2_2)
      XCTAssertTrue(n1_2_1.topMost() === n1)
      XCTAssertFalse(n1_2_1.topMost() === n1_2)
      XCTAssertFalse(n1_2_1.topMost() === root)

      _ = root.add(children: n1, n2)
      XCTAssertTrue(n1_2_1.topMost() === root)
      XCTAssertFalse(n1_2_1.topMost() === n1)
      XCTAssertFalse(n1_2_1.topMost() === n1_2)
    }
    func getStart() {
      let root = SqlNode()
      let n1 = SelectExpression()
      let n2 = SqlNode()
      let n1_1 = SqlNode()
      let n1_2 = SqlNode()
      let n2_1 = SqlNode()
      let n2_2 = SqlNode()
      let n1_2_1 = SelectExpression()

      _ = n1_2.add(child: n1_2_1)
      _ = n1.add(children: n1_1, n1_2)
      _ = n2.add(children: n2_1, n2_2)
      _ = root.add(children: n1, n2)

      XCTAssertTrue(n1_2_1.getStart() === n1_2_1)
      XCTAssertTrue(n1_2.getStart() === n1)
      XCTAssertFalse(n2_2.getStart() === n1)
      XCTAssertTrue(root.getStart() == nil)
    }
    func subscriptWithCondition() {
      let root = RootNode.initialize()
        .select("e.id", "e.firstname", "e.lastname", "p.level", "acc.balc")
        .from{
          _ = $0.t("EMPLOYEE").as("e")
          .leftOuterJoin("POINT").as("p")
          .on("e.id = p.emp_id")
          .leftOuterJoin{
            _ = $0.select().t("a.emp_id").as("emid")
              .t("a.balance").as("balc")
              .t("a.address").as("addr").getStart()!
              .from("ACCOUNT", as: "a")
              .where().and("a.balance > 3000").lcId("balAmount")
                .or("a.openDate > '2011-01-01'").lcId("oDate")
          }.as("acc")
          .on("e.id = acc.emid")
        }
        .where("MONTH(e.birth) = 3", "YEAR(e.startDate) = 2010")

      let sql = "SELECT e.id, e.firstname, e.lastname, p.level, acc.balc\n"
        + "FROM EMPLOYEE as e\n"
        + "LEFT OUTER JOIN POINT as p\n"
        + "ON e.id = p.emp_id\n"
        + "LEFT OUTER JOIN (SELECT a.emp_id as emid, a.balance as balc, a.address as addr\n"
        + "FROM ACCOUNT as a\n"
        + "WHERE a.balance > 3000 OR a.openDate > '2011-01-01') as acc\n"
        + "ON e.id = acc.emid\n"
        + "WHERE MONTH(e.birth) = 3 AND YEAR(e.startDate) = 2010"
      XCTAssertEqual(sql, root.toSql())

      let f1 = root[.id("balAmount")]
      XCTAssertTrue(f1 as? SimpleCondition != nil)
      XCTAssertEqual("a.balance > 3000", (f1 as! SimpleCondition).expression)

      let f2 = root[.id("oDate")]
      XCTAssertTrue(f2 as? SimpleCondition != nil)
      XCTAssertEqual("a.openDate > '2011-01-01'", (f2 as! SimpleCondition).expression)

      let f3 = root[.alias("a")]
      XCTAssertTrue(f3 as? SimpleExpression != nil)
      XCTAssertEqual("ACCOUNT", (f3 as! SimpleExpression).expression)

      let f4 = root[.alias("acc")]
      XCTAssertTrue(f4 as? SelectExpression != nil)
      let select = "(SELECT a.emp_id as emid, a.balance as balc, a.address as addr\n"
        + "FROM ACCOUNT as a\n"
        + "WHERE a.balance > 3000 OR a.openDate > '2011-01-01') as acc"
      XCTAssertEqual(select, (f4 as! SelectExpression).toSql())

      let f5 = root[.expression("a.balance > 3000")]
      XCTAssertTrue(f5 as? SimpleCondition != nil)
      XCTAssertEqual("a.balance > 3000", (f5 as! SimpleCondition).expression)
    }
    func copy() {
      let root = SqlNode()
      let c1 = SqlNode()
      let c2 = SqlNode()
      let c3 = SqlNode()
      let c1_1 = SqlNode().id("c1_1")
      let c1_2 = SqlNode().id("c1_2")

      _ = root.add(children: c1, c2, c3)
      _ = c1.add(children: c1_1, c1_2)

      let factory = SqlNodeFactory.initialize()
      root.factory = factory
      let id = "This is root node"
      root.id = id

      let copyRoot = root.copy()
      XCTAssertFalse(root === copyRoot)
      //XCTAssertTrue(copyRoot is SqlNode)
      XCTAssertTrue(factory === copyRoot.factory)
      XCTAssertEqual(id, copyRoot.id)

      let copy_c1_1 = copyRoot[0, 0]!
      let copy_c1_2 = copyRoot[0, 1]!

      XCTAssertFalse(c1_1 === copy_c1_1)
      XCTAssertFalse(c1_2 === copy_c1_2)
      XCTAssertEqual("c1_1", copy_c1_1.id)
      XCTAssertEqual("c1_2", copy_c1_2.id)
    }
    static var allTests = [
        ("create", create),
        ("root", root),
        ("topMost", topMost),
        ("getStart", getStart),
        ("subscriptWithCondition", subscriptWithCondition),
        ("copy", copy),
    ]
}
