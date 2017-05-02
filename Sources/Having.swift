open class Having: FilterConditions {
  override open func toSql() -> String {
    let sql = super.conditionSql()
    if !sql.isEmpty {
      return "HAVING " + sql
    }
    return ""
  }
  override open func copy() -> Having {
    let copy = super.copy() as! Having
    return copy
  }
}
