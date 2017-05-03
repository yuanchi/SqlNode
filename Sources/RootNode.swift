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
  
}
