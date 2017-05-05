import TreeNode
open class SqlNode: TreeNode, Identifiable {

  public var id = ""
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
  public subscript(_ searchStrategy: SingleNodeSearchable) -> SqlNode? {
    let found = searchStrategy.get(from: self)
    return found
  }
  /*
  * Although SearchType conforms to SingleNodeSearchable,
  * I think this overload is required for sussinct use.
  * Without overload ex. SqlNode()[SearchType.id("abc")]
  * With overload ex. SqlNode()[.id("abc")]
  */
  public subscript(_ searchType: SearchType) -> SqlNode? {
    let found = searchType.get(from: self)
    return found
  }
  /*
  * All inner SqlNodes are initializd via this method.
  * When this method is called, it firstly searches the top most node to check if there is the factory.
  * If there is no factory existed on the top most node, it will initialize one on its own.
  * My intent is to keep the consistency, flexibility configurable, use convenience, and try to reduce memory consumption.
  */
  public func create<T:SqlNode>(with key: T.Type) -> T {
    if let node = topMost().factory?.create(with: key) {
      return node
    }
    if self.factory == nil {
      self.factory = SqlNodeFactory.shared
    }
    return self.factory!.create(with: key)
  }
  public func configFactory(with config: (SqlNodeFactory) -> Void) -> Self {
    if self.factory == nil || self.factory === SqlNodeFactory.shared {
      self.factory = SqlNodeFactory.newInstance()
    }
    config(self.factory!)
    return self
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
  override open func copy() -> SqlNode {
    let copy = super.copy() as! SqlNode
    copy.id = self.id
    copy.factory = self.factory
    return copy
  }
}
