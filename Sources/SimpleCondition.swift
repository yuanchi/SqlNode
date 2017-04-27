open class SimpleCondition: SqlNode, Junctible, SingleParameterizable, Expressible {
  var junction: Junction = .AND
  var expression = ""
  lazy var param: SqlParameter? = SqlParameter()

  override open func toSql() -> String {
    return "\(prefixJunction())\(expression)"
  }
}
