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

    static var allTests = [
        ("create", create),
        ("root", root),
        ("topMost", topMost),
        ("getStart", getStart)
    ]
}
