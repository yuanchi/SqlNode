open class Where: FilterConditions {
  override open func toSql() -> String {
    let condSql = super.conditionSql()
    return !condSql.isEmpty ? "WHERE \(condSql)" : ""
  }
  override open func copy() -> Where {
    let copy = super.copy() as! Where
    return copy
  }
}
