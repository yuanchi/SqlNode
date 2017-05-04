public class SqlNodeFactory {
  var registers: [ObjectIdentifier: ()-> SqlNode]
  open class func initRegisters() -> [ObjectIdentifier: () -> SqlNode]{
    let defaults: [ObjectIdentifier: () -> SqlNode] = [
    ObjectIdentifier(SelectExpression.self): SqlNodeFactory.initSelectExpression,
      ObjectIdentifier(Select.self): SqlNodeFactory.initSelect,
      ObjectIdentifier(From.self): SqlNodeFactory.initFrom,
      ObjectIdentifier(Where.self): SqlNodeFactory.initWhere,
      ObjectIdentifier(OrderBy.self): SqlNodeFactory.initOrderBy,
      ObjectIdentifier(GroupBy.self): SqlNodeFactory.initGroupBy,
      ObjectIdentifier(Having.self): SqlNodeFactory.initHaving,
      ObjectIdentifier(FilterConditions.self): SqlNodeFactory.initFilterConditions,
      ObjectIdentifier(TargetExpressible.self): SqlNodeFactory.initTargetExpressible,
      ObjectIdentifier(SimpleCondition.self): SqlNodeFactory.initSimpleCondition,
      ObjectIdentifier(SubqueryCondition.self): SqlNodeFactory.initSubqueryCondition,
      ObjectIdentifier(On.self): SqlNodeFactory.initOn,
      ObjectIdentifier(SimpleExpression.self): SqlNodeFactory.initSimpleExpression,
      ObjectIdentifier(JoinExpression.self): SqlNodeFactory.initJoinExpression,
      ObjectIdentifier(JoinSubquery.self): SqlNodeFactory.initJoinSubquery
    ]
    return defaults
  }
  public init() {
    registers = SqlNodeFactory.initRegisters()
  }
  public func addOrReplace(with key: SqlNode.Type, _ factory: @escaping () -> SqlNode) -> Self {
    registers[ObjectIdentifier(key)] = factory
    return self
  }

  public func add(with key: SqlNode.Type, _ factory: @escaping () -> SqlNode) -> Self {
    return addOrReplace(with: key, factory)
  }

  public func replace(with key: SqlNode.Type, _ factory: @escaping () -> SqlNode) -> Self {
    return addOrReplace(with: key, factory)
  }

  public func create<T: SqlNode>(with key: T.Type) -> T {
    let id = ObjectIdentifier(key)
    precondition(
      registers[id] != nil,
      "key: \(key) not found")
    return registers[id]!() as! T
  }
  public class func initialize() -> SqlNodeFactory {
    return SqlNodeFactory()
  }
  static func initSelectExpression() -> SelectExpression {
    return SelectExpression()
  }
  static func initSelect() -> Select {
    return Select()
  }
  static func initFrom() -> From {
    return From()
  }
  static func initWhere() -> Where {
    return Where()
  }
  static func initOrderBy() -> OrderBy {
    return OrderBy()
  }
  static func initGroupBy() -> GroupBy {
    return GroupBy()
  }
  static func initHaving() -> Having {
    return Having()
  }
  static func initFilterConditions() -> FilterConditions {
    return FilterConditions()
  }
  static func initTargetExpressible() -> TargetExpressible {
    return TargetExpressible()
  }
  static func initSimpleCondition() -> SimpleCondition {
    return SimpleCondition()
  }
  static func initSubqueryCondition() -> SubqueryCondition {
    return SubqueryCondition()
  }
  static func initOn() -> On {
    return On()
  }
  static func initSimpleExpression() -> SimpleExpression {
    return SimpleExpression()
  }
  static func initJoinExpression() -> JoinExpression {
    return JoinExpression()
  }
  static func initJoinSubquery() -> JoinSubquery {
    return JoinSubquery()
  }
}
