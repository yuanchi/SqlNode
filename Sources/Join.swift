open class Join: SqlNode {
  var type: String = ""
  override open func toSql() -> String {
    return type
  }
  override open func copy() -> Join {
    let copy = super.copy() as! Join
    copy.type = self.type
    return copy
  }
}
