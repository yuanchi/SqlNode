open class JoinSubquery: JoinExpression {
  public typealias Me = JoinSubquery
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
}
