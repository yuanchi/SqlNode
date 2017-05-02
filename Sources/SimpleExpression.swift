open class SimpleExpression: SqlNode, SelfAliasible, Expressible {
  public typealias Me = SimpleExpression
  public var alias: String = ""
  public var expression: String = ""
  override open func toSql() -> String {
    if alias.isEmpty {
      return expression
    }
    return "\(expression) as \(alias)"
  }
  override open func copy() -> SimpleExpression {
    let copy = super.copy() as! SimpleExpression
    copy.alias = self.alias
    copy.expression = self.expression
    return copy
  }
}
