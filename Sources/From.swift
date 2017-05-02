open class From: TargetExpressible {
  public func addJoin(with type: String) -> Self {
    let join = create(with: Join.self)
    join.type = type
    return add(child: join)
  }
  public func join() -> Self {
    return addJoin(with: "JOIN")
  }
  public func join(_ target: String) -> Self {
    return self.join().t(target)
  }
  public func join(_ config: (SelectExpression) -> Void) -> Self {
    _ = self.join().subquery(with: config)
    return self
  }
  public func innerJoin() -> Self {
    return self.addJoin(with: "INNER JOIN")
  }
  public func innerJoin(_ target: String) -> Self {
    return self.innerJoin().t(target)
  }
  public func innerJoin(_ config: (SelectExpression) -> Void) -> Self {
    _ = self.innerJoin().subquery(with: config)
    return self
  }
  public func leftOuterJoin() -> Self {
    return self.addJoin(with: "LEFT OUTER JOIN")
  }
  public func leftOuterJoin(_ target: String) -> Self {
    return self.leftOuterJoin().t(target)
  }
  public func leftOuterJoin(_ config: (SelectExpression) -> Void) -> Self {
    _ = self.leftOuterJoin().subquery(with: config)
    return self
  }
  public func rightOuterJoin() -> Self {
    return self.addJoin(with: "RIGHT OUTER JOIN")
  }
  public func rightOuterJoin(_ target: String) -> Self {
    return self.rightOuterJoin().t(target)
  }
  public func rightOuterJoin(_ config: (SelectExpression) -> Void) -> Self {
    _ = self.rightOuterJoin().subquery(with: config)
    return self
  }
  public func crossJoin() -> Self {
    return self.addJoin(with: "CROSS JOIN")
  }
  public func crossJoin(_ target: String) -> Self {
    return self.crossJoin().t(target)
  }
  public func crossJoin(_ config: (SelectExpression) -> Void) -> Self {
    _ = self.crossJoin().subquery(with: config)
    return self
  }
  public func on() -> On {
    let on = create(with: On.self)
    _ = add(child: on)
    return on
  }
  public func on(_ expressions: String...) -> Self {
    let on = self.on()
    for e in expressions {
      _ = on.and(e)
    }
    return self
  }
  override open func toSql() -> String {
    let joinFound = sqlChildren.contains{ element in
        return element is Join || element is On
    }
    var r = ""
    if joinFound {
      let first = sqlChildren.first
      r = sqlChildren.map{ element in
        let sql = element.toSql()
        if element is SimpleExpression || element is SelectExpression {
          return element === first ? sql : " \(sql)"
        }
        if element is Join || element is On {
          return "\n\(sql)"
        }
        return sql
      }.joined(separator: "")
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
}
