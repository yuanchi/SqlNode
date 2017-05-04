open class JoinSubquery: TargetExpressible, Joinable {
  var joinType: String = ""

  public func on() -> On {
    let on = create(with: On.self)
    _ = add(child: on)
    return on
  }
  override open func copy() -> JoinSubquery {
    let copy = super.copy() as! JoinSubquery
    copy.joinType = self.joinType
    return copy
  }
  override open func toSql() -> String {
    let childrenSql = sqlChildren.map { $0.toSql() }.joined(separator: "\n ")
    let r = [joinType, childrenSql]
      .filter { !$0.isEmpty }
      .joined(separator: " ")
    return r
  }
}
