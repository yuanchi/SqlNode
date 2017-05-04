open class JoinExpression: SqlNode, SelfAliasible, Expressible, Joinable {
  public typealias Me = JoinExpression
  public var joinType: String = ""
  public var alias: String = ""
  public var expression: String = ""

  public func on() -> On {
    let on = create(with: On.self)
    _ = add(child: on)
    return on
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
    copy.alias = self.alias
    copy.expression = self.expression
    return copy
  }
}
