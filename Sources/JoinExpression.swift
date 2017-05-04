open class JoinExpression: SimpleExpression  {
  public typealias Me = JoinExpression
  public var joinType: String = ""

  public func join(with type: String) -> Self {
    self.joinType = type
    return self
  }
  public func on() -> On {
    let on = create(with: On.self)
    _ = add(child: on)
    return on
  }
  public func on(_ conditions: [String]) -> Self {
    let on = self.on()
    for c in conditions {
      _ = on.and(c)
    }
    return self
  }
  override open func toSql() -> String {
    let aliasExpr = alias.isEmpty ? alias : "as \(alias)"
    var r = [joinType, expression, aliasExpr]
      .filter { !$0.isEmpty }
      .joined(separator: " ")

    let childrenSql = sqlChildren.map { $0.toSql() }.joined(separator: " ")
    r = childrenSql.isEmpty ? r : (r + "\n " + childrenSql)
    return r
  }
  override open func copy() -> JoinExpression {
    let copy = super.copy() as! JoinExpression
    copy.joinType = self.joinType
    return copy
  }
}
