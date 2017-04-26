open class FilterConditions: SqlNode, Junctible {
  var junction: Junction = .AND

  public func junctConds(with config: (FilterConditions) -> Void, _ junction: Junction) -> FilterConditions {
    let fc = create(with: FilterConditions.self)
    fc.junction = junction
    config(fc)
    _ = add(child: fc)
    return fc
  }
  public func and(_ config: (FilterConditions) -> Void) -> Self {
    _ = junctConds(with: config, .AND)
    return self
  }
  public func or(_ config: (FilterConditions) -> Void) -> Self {
    _ = junctConds(with: config, .OR)
    return self
  }

  public func junctCond(with junction: Junction) -> SimpleCondition {
    let sc = create(with: SimpleCondition.self)
    sc.junction = junction
    _ = add(child: sc)
    return sc
  }
  public func and(_ expression: String) -> Self {
    let sc = junctCond(with: .AND)
    sc.expression = expression
    return self
  }
  public func or(_ expression: String) -> Self {
    let sc = junctCond(with: .OR)
    sc.expression = expression
    return self
  }

  public func junctSubquery(with junction: Junction) -> SubqueryCondition {
    let sc = create(with: SubqueryCondition.self)
    sc.junction = junction
    _ = add(child: sc)
    return sc
  }
  public func and(prefix: String, config: (SelectExpression) -> Void) -> Self {
    let sc = junctSubquery(with: .AND)
    sc.prefix = prefix
    _ = sc.subquery(with: config)
    return self
  }
  public func or(prefix: String, config: (SelectExpression) -> Void) -> Self {
    let sc = junctSubquery(with: .OR)
    sc.prefix = prefix
    _ = sc.subquery(with: config)
    return self
  }
  func conditionSql() -> String {
    if sqlChildren.isEmpty {
      return ""
    }
    let firstJunct = (sqlChildren.first as! Junctible).prefixJunction()
    var r = sqlChildren.map{ $0.toSql() }
      .joined(separator: " ")
    let range = firstJunct.startIndex..<firstJunct.endIndex
    r.characters.removeSubrange(range)
    return r
  }
  override open func toSql() -> String {
    let condSql = conditionSql()
    return !condSql.isEmpty ? "(\(condSql))" : ""
  }
}
