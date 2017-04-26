open class Where: FilterConditions {
  override open func toSql() -> String {
    let condSql = super.conditionSql()
    return !condSql.isEmpty ? "WHERE \(condSql)" : ""
  }
}
