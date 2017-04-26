open class OrderBy: TargetExpressible {
  override open func toSql() -> String {
    let r = super.toSql()
    return !r.isEmpty ? "ORDER BY \(r)" : ""
  }
}
