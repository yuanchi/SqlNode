open class Select: TargetExpressible {
  override open func toSql() -> String {
    let body = super.toSql()
    return body.isEmpty ? "" : "SELECT \(body)"
  }
  override open func copy() -> Select {
    let copy = super.copy() as! Select
    return copy
  }
}
