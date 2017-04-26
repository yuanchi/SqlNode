open class Select: TargetExpressible {
  override open func toSql() -> String {
    let body = super.toSql()
    return body.isEmpty ? "" : "SELECT \(body)"
  }
}
