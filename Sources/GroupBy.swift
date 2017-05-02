open class GroupBy: TargetExpressible {
  override open func toSql() -> String {
    return "GROUP BY " + super.toSql()
  }
  override open func copy() -> GroupBy {
    let copy = super.copy() as! GroupBy
    return copy
  }
}
