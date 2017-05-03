open class RootNode: SelectExpression {
  public var pageNavigator: PageNavigator?

  public class func initialize() -> RootNode {
    let root = RootNode()
    root.factory = SqlNodeFactory.initialize()
    return root
  }
  override open func copy() -> RootNode {
    let copy = super.copy() as! RootNode
    return copy
  }
  /*
  * collect all paramter values, conforming to SqlParameterizable
  */
  public func paramVals() -> [Any] {
    var first = find { $0 is SingleParameterizable }
      .flatMap { ($0 as? SingleParameterizable)?.paramVal }

    let second = find { $0 is MultiParameterizable }
      .flatMap {
        ($0 as? MultiParameterizable)?.params.flatMap { $0.val }
      }/*
      .reduce([Any]()) { (results, vals) in
        var merged = results
        merged = merged + vals
        return merged
      }*/
      .reduce([], +)

    first = first + second
    return first
  }
}
