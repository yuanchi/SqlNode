import TreeNode
open class SqlNode: TreeNode {

  public var factory: SqlNodeFactory?
  public var root: RootNode? {
    return topMost() as? RootNode
  }
  public var sqlParent: SqlNode? {
    return parent as? SqlNode
  }
  public var sqlChildren: [SqlNode] {
    return children as! [SqlNode]
  }

  override open subscript(idx: Int...) -> SqlNode? {
    return findChildBy(idx: idx)
  }
  public func create<T:SqlNode>(with key: T.Type) -> T {
    if let node = topMost().factory?.create(with: key) {
      return node
    }
    if self.factory == nil {
      self.factory = SqlNodeFactory.initialize()
    }
    return self.factory!.create(with: key)
  }
  public func topMost() -> SqlNode {
    return topMost(as: SqlNode.self)!
  }
  open func toSql() -> String {
    fatalError("toSql method not overrided")
  }
  public func getStart() -> SelectExpression? {
    return closest(to: SelectExpression.self)
  }

}
