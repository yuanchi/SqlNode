open class SimpleCondition: SqlNode, Junctible {
  var junction: Junction = .AND
  var expression = ""
  override open func toSql() -> String {
    return "\(prefixJunction())\(expression)"
  }
}
