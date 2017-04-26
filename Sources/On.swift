open class On: FilterConditions {
  override open func toSql() -> String {
    let condSql = super.conditionSql()
    return !condSql.isEmpty ? "ON \(condSql)" : ""
  }
}
