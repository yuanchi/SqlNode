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
  /*
  * if the last child is SingleParameterizable, add param value to it
  */
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
    var r = sqlChildren.first!.toSql()
    let separator = " "
    for (idx, ele) in sqlChildren.enumerated() {
      if idx == 0 {
        continue
      }
      if let junc = ele as? Junctible {
        r += (separator + junc.prefixJunction() + ele.toSql())
      } else {
        r += (separator + ele.toSql())
      }
    }
    return r
  }
  override open func toSql() -> String {
    let condSql = conditionSql()
    guard !condSql.isEmpty else {
      return ""
    }
    return  children.count > 1 && parent != nil ? "(\(condSql))" : "\(condSql)"
  }
  public func removeConditionsWithParamValNil() -> Self {
    _ = removeIf {
      $0 is SingleParameterizable
      && ($0 as! SingleParameterizable).paramVal == nil
    }
    return self
  }
  /*
  * access all not nil param values(with Array.flatMap(_:))
  */
  public func condParamVals() -> [Any] {
    return find { $0 is SingleParameterizable } // transfrom nested structure to array
      .flatMap { ($0 as? SingleParameterizable)?.paramVal }
  }
  static func getParamName(of input: String) -> String? {
    if let idx = input.characters.index(of: ":") {
      let pos = input.distance(from: input.startIndex, to: idx) + 1
      let name = input[input.index(input.startIndex, offsetBy: pos)..<input.endIndex]
      return name
    }
    return nil
  }
  public func namedParamVals() -> [String: Any] {
    return find {
      $0 is SimpleCondition
      && ($0 as! SimpleCondition).paramVal != nil
    }/*
    .map { (s: TreeNode) -> (String, Any) in
      let cond = s as! SimpleCondition
      let name = FilterConditions.getParamName(of: cond.expression)!
      let pv = cond.paramVal!
      return (name, pv)
    }
    .reduce([String: Any]()) { (result, kvpair) in
      var dict = result
      dict[kvpair.0] = kvpair.1
      return dict
    }*/
    .reduce([String: Any]()) { (result, condition) in
      let cond = condition as! SimpleCondition
      let pv = cond.paramVal!
      let name = FilterConditions.getParamName(of: cond.expression)!
      var dict = result
      dict[name] = pv
      return dict
    }
  }
  override open func copy() -> FilterConditions {
    let copy = super.copy() as! FilterConditions
    copy.junction = self.junction
    return copy
  }
}
