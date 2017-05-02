open class SimpleCondition: SqlNode, Junctible, SingleParameterizable, Expressible {
  var junction: Junction = .AND
  var expression = ""
  lazy var param: SqlParameter? = SqlParameter()

  override open func toSql() -> String {
    return "\(expression)"
  }
  override open func copy() -> SimpleCondition {
    let copy = super.copy() as! SimpleCondition
    copy.junction = self.junction
    copy.expression = self.expression
    copy.param = self.param
    return copy
  }
}
