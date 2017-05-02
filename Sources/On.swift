open class On: FilterConditions {
  override open func toSql() -> String {
    let condSql = super.conditionSql()
    return !condSql.isEmpty ? "ON \(condSql)" : ""
  }
  override open func copy() -> On {
    let copy = super.copy() as! On
    return copy
  }
}
