open class JoinExpression: SqlNode, SelfAliasible, Expressible  {
  public typealias Me = JoinExpression
  public var alias: String = ""
  public var expression: String = ""
  public var joinType: String = ""

  public func join(with type: String) -> Self {
    self.joinType = type
    return self
  }
  public func on() -> On {
    let on = create(with: On.self)
    _ = add(child: on)
    return on
  }
  public func on(_ conditions: String...) -> Self {
    let on = self.on()
    for c in conditions {
      _ = on.and(c)
    }
    return self
  }
}
