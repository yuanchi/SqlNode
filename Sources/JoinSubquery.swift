open class JoinSubquery: JoinExpression {
  public typealias Me = JoinSubquery
  public func subquery() -> SelectExpression {
    let se = create(with: SelectExpression.self)
    _ = add(child: se)
    return se
  }
  public func subquery(with config: (SelectExpression)-> Void) -> Self {
    let se = subquery()
    config(se)
    return self
  }
  public func `as`(with alias: String) {
    if let found = children.first(where: { $0 is SelectExpression }) as? SelectExpression {
      found.alias = alias
    }
  }
  override open func copy() -> JoinSubquery {
    let copy = super.copy() as! JoinSubquery
    return copy
  }
  override open func toSql() -> String {
    let childrenSql = sqlChildren.map { $0.toSql() }.joined(separator: "\n ")
    let r = [joinType, childrenSql]
      .filter { !$0.isEmpty }
      .joined(separator: " ")
    return r
  }
}
