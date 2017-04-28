import TreeNode
open class SqlNode: TreeNode, Identifiable {

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
  public var id = ""

  override open subscript(idx: Int...) -> SqlNode? {
    return findChildBy(idx: idx)
  }
  public subscript(_ condition: SearchType) -> SqlNode? {
    let val = condition.val
    var found: SqlNode? = nil
    switch condition {
    case .id(_):
      found = findFirst { n in
        if let casted = n as? Identifiable {
          return casted.id == val
        }
        return false
      } as? SqlNode
    case .alias(_):
      found = findFirst { n in
        if let casted = n as? Aliasible {
          return casted.alias == val
        }
        return false
      } as? SqlNode
    case .expression(_):
      found = findFirst { n in
        if let casted = n as? Expressible {
          return casted.expression == val
        }
        return false
      } as? SqlNode
    }
    return found
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
  /*
  * config self id
  */
  public func id(_ id: String) -> Self {
    self.id = id
    return self
  }
  /*
  * config last child id
  */
  public func lcId(_ id: String) -> Self {
    if let f = sqlChildren.last {
      f.id = id
    }
    return self
  }
}
