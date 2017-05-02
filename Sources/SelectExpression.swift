import TreeNode
open class SelectExpression: SqlNode, SelfAliasible {
  public typealias Me = SelectExpression
  public var alias = ""

  func findFirstOrNew<T: SqlNode> (with type: T.Type) -> T {
    if let found = children.first(where: {type(of: $0) == type}) {
      return found as! T
    }
    let created = create(with: type)
    _ = add(child: created)
    return created
  }
  public func select() -> Select {
    return findFirstOrNew(with: Select.self)
  }
  public func select(_ targets: String...) -> Self {
    let select = self.select()
    for t in targets {
      _ = select.t(t)
    }
    return self
  }
  public func select(with config: (Select) -> Void) -> Self {
    let select = self.select()
    config(select)
    return self
  }
  public func from() -> From {
    return findFirstOrNew(with: From.self)
  }
  public func from(_ targets: String...) -> Self {
    let from = self.from()
    for t in targets {
      _ = from.t(t)
    }
    return self
  }
  public func from(with config: (From) -> Void) -> Self {
    let from = self.from()
    config(from)
    return self
  }
  public func from(_ target: String, `as` alias: String) -> Self {
    _ = self.from().t(target).`as`(alias)
    return self
  }
  public func `where`() -> Where {
    return findFirstOrNew(with: Where.self)
  }
  public func `where`(_ targets: String...) -> Self {
    let w = self.`where`()
    for t in targets {
      _ = w.and(t)
    }
    return self
  }
  public func `where`(with config: (Where) -> Void) -> Self {
    let w = self.`where`()
    config(w)
    return self
  }
  public func orderBy() -> OrderBy {
    return findFirstOrNew(with: OrderBy.self)
  }
  public func orderBy(_ targets: String...) -> Self {
    let orderBy = self.orderBy()
    for t in targets {
      _ = orderBy.t(t)
    }
    return self
  }
  public func orderBy(with config: (OrderBy) -> Void) -> Self {
    let orderBy = self.orderBy()
    config(orderBy)
    return self
  }
  private static func readingOrder<T: TreeNode>(of instance: T) -> Int {
    switch instance {
    case is Select:
      return 1
    case is From:
      return 2
    case is Where:
      return 3
    case is OrderBy:
      return 4
    case is GroupBy:
      return 5
    case is Having:
      return 6
    default:
      return 7
    }
  }
  override open func toSql() -> String {
    children.sort{
      let first = SelectExpression.readingOrder(of: $0)
      let second = SelectExpression.readingOrder(of: $1)
      return first - second < 0
    }
    let s = "\n"
    var r = sqlChildren.map{ $0.toSql()}
      .filter{ !$0.isEmpty }
      .joined(separator: s)
    if parent != nil {
      r = "(\(r))"
      r = alias.isEmpty ? r : "\(r) as \(alias)"
    }
    return r
  }
  override open func copy() -> SelectExpression {
    let copy = super.copy() as! SelectExpression
    copy.alias = self.alias
    return copy
  }
}
