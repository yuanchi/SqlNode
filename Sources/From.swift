open class From: TargetExpressible {
  override public func `as`(_ alias: String) -> Self {
    if let found = children.last as? JoinSubquery {
      _ = found.as(alias)
      return self
    }
    _ = super.as(alias)
    return self
  }
  func joinExpression() -> JoinExpression {
    let je = create(with: JoinExpression.self)
    _ = add(child: je)
    return je
  }
  func joinSubquery() -> JoinSubquery {
    let js = create(with: JoinSubquery.self)
    _ = add(child: js)
    return js
  }
  func join(with type: String, _ target: String) -> Self {
    let je = joinExpression()
    je.joinType = type
    je.expression = target
    return self
  }
  func join(with type: String, _ config: (SelectExpression) -> Void) -> Self {
    let js = joinSubquery()
    js.joinType = type
    _ = js.subquery(with: config)
    return self
  }
  public func join(_ target: String) -> Self {
    return join(with: "JOIN", target)
  }
  public func join(_ config: (SelectExpression) -> Void) -> Self {
    return join(with: "JOIN", config)
  }
  public func innerJoin(_ target: String) -> Self {
    return join(with: "INNER JOIN", target)
  }
  public func innerJoin(_ config: (SelectExpression) -> Void) -> Self {
    return join(with: "INNER JOIN", config)
  }
  public func leftOuterJoin(_ target: String) -> Self {
    return join(with: "LEFT OUTER JOIN", target)
  }
  public func leftOuterJoin(_ config: (SelectExpression) -> Void) -> Self {
    return join(with: "LEFT OUTER JOIN", config)
  }
  public func rightOuterJoin(_ target: String) -> Self {
    return join(with: "RIGHT OUTER JOIN", target)
  }
  public func rightOuterJoin(_ config: (SelectExpression) -> Void) -> Self {
    return join(with: "RIGHT OUTER JOIN", config)
  }
  public func crossJoin(_ target: String) -> Self {
    return join(with: "CROSS JOIN", target)
  }
  public func crossJoin(_ config: (SelectExpression) -> Void) -> Self {
    return join(with: "CROSS JOIN", config)
  }
  public func on() -> On {
    return (children.last as! Joinable).on()
  }
  public func on(_ conditions: String...) -> Self {
    _ = (children.last as! Joinable).on(conditions)
    return self
  }
  override open func toSql() -> String {
    let joinFound = sqlChildren.contains { $0 is Joinable }
    var r = ""
    if joinFound {
      r = sqlChildren
        .map { $0.toSql() }
        .filter { !$0.isEmpty }
        .joined(separator: "\n")
    } else {
      r = super.toSql()
    }
    r = r.isEmpty ? r : "FROM \(r)"
    return r
  }
  override open func copy() -> From {
    let copy = super.copy() as! From
    return copy
  }
  public func removeIfNotReferenced() -> Self {
    // TODO
    return self
  }
}
