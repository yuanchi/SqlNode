open class SubqueryCondition: TargetExpressible, Junctible {
  var junction: Junction = .AND
  var prefix = ""
  override open func toSql() -> String {
    if let first = sqlChildren.first(where: { $0 is SelectExpression}) {
      let selectExpr = first.toSql()
      return "\(prefix) \(selectExpr)"
    }
    return ""
  }
  override open func copy() -> SubqueryCondition {
    let copy = super.copy() as! SubqueryCondition
    copy.junction = self.junction
    copy.prefix = self.prefix
    return copy
  }
}
