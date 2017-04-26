open class SimpleExpression: SqlNode, SelfAliasible {
  public typealias Me = SimpleExpression
  public var alias: String = ""
  public var expression: String = ""
  override open func toSql() -> String {
    if alias.isEmpty {
      return expression
    }
    return "\(expression) as \(alias)"
  }
}
