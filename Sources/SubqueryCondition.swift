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
}
