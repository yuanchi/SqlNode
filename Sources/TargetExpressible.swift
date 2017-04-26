open class TargetExpressible: SqlNode {
  public func t(_ expression: String) -> Self {
    let se = create(with: SimpleExpression.self)
    se.expression = expression
    return add(child: se)
  }
  public func `as`(_ alias: String) -> Self {
    var found = children.last as? Aliasible
    precondition(
      found != nil,
      "last child not existed or its type is not Aliasible"
    )
    found!.`as`(with: alias)
    return self
  }
  public func subquery() -> SelectExpression {
    let se = create(with: SelectExpression.self)
    _ = add(child: se)
    return se
  }
  public func subquery(with config: (SelectExpression)-> Void) -> Self {
    let se = subquery()
    config(se)
    return self
  }
  override open func toSql() -> String {
    let separator = !sqlChildren.contains(where: { $0 is SelectExpression})
      ? ", "
      : ",\n"
    let sql = sqlChildren.map{ $0.toSql() }.joined(separator: separator)
    return sql
  }
}
