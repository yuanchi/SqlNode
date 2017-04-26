open class Join: SqlNode {
  var type: String = ""
  override open func toSql() -> String {
    return type
  }
}
