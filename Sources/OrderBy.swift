open class OrderBy: TargetExpressible {
  override open func toSql() -> String {
    let r = super.toSql()
    return !r.isEmpty ? "ORDER BY \(r)" : ""
  }
  override open func copy() -> OrderBy {
    let copy = super.copy() as! OrderBy
    return copy
  }
}
