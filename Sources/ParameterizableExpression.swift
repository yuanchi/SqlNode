open class ParameterizableExpression: CustomExpression, MultiParameterizable {
  lazy public var params: [SqlParameter] = []
  override open func copy() -> ParameterizableExpression {
    let copy = super.copy() as! ParameterizableExpression
    copy.params = self.params
    return copy
  }
}
