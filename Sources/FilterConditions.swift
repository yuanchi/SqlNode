open class FilterConditions: SqlNode, Junctible {
  var junction: Junction = .AND

  public func junctSingleCond(with junction: Junction) -> SimpleCondition {
    let sc = create(with: SimpleCondition.self)
    sc.junction = junction
    _ = add(child: sc)
    return sc
  }
  public func and(_ singleCond: String) -> Self {
    let sc = junctSingleCond(with: .AND)
    sc.expression = singleCond
    return self
  }
  public func or(_ singleCond: String) -> Self {
    let sc = junctSingleCond(with: .OR)
    sc.expression = singleCond
    return self
  }

  public func junctMultiConds(with junction: Junction, _ config: (FilterConditions) -> Void) -> FilterConditions {
    let fc = create(with: FilterConditions.self)
    fc.junction = junction
    config(fc)
    _ = add(child: fc)
    return fc
  }
  public func and(_ multiConds: (FilterConditions) -> Void) -> Self {
    _ = junctMultiConds(with: .AND, multiConds)
    return self
  }
  public func or(_ multiConds: (FilterConditions) -> Void) -> Self {
    _ = junctMultiConds(with: .OR, multiConds)
    return self
  }

  public func junctSubqueryCondition(with junction: Junction) -> SubqueryCondition {
    let sc = create(with: SubqueryCondition.self)
    sc.junction = junction
    _ = add(child: sc)
    return sc
  }
  public func and(_ prefix: String, _ config: (SelectExpression) -> Void) -> Self {
    let sc = junctSubqueryCondition(with: .AND)
    sc.prefix = prefix
    _ = sc.subquery(with: config)
    return self
  }
  public func or(_ prefix: String, _ config: (SelectExpression) -> Void) -> Self {
    let sc = junctSubqueryCondition(with: .OR)
    sc.prefix = prefix
    _ = sc.subquery(with: config)
    return self
  }
  public func paramVal(_ val: Any) -> Self {
    if var f = children.last as? SingleParameterizable {
      f.paramVal = val
    }
    return self
  }
  public func conditionSql() -> String {
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
    guard !condSql.isEmpty else {
      return ""
    }
    return  children.count == 1 ? "\(prefixJunction())\(condSql)" : "\(prefixJunction())(\(condSql))"
  }
  public func removeConditionsWithParamValNil() -> Self {
    _ = removeIf{
      $0 is SingleParameterizable
      && ($0 as! SingleParameterizable).paramVal == nil
    }
    return self
  }
  /*
  * access all not nil param values(with Array.flatMap(_:))
  */
  public func condParamVals() -> [Any] {
    return find{ $0 is SingleParameterizable } // transfrom nested structure to array
      .flatMap{ ($0 as? SingleParameterizable)?.paramVal }
  }
}
