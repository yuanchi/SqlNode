open class CustomExpression: SqlNode, Expressible {
  public var expression = ""
  required public init() {}
  required public init(_ expression: String) {
    super.init()
    self.expression = expression
  }
  override open func toSql() -> String {
    return expression
  }
  override open func copy() -> CustomExpression {
    let copy = super.copy() as! CustomExpression
    copy.expression = self.expression
    return copy
  }
}
