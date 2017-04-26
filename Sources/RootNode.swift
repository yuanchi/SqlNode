open class RootNode: SelectExpression {

  public class func initialize() -> RootNode {
    let root = RootNode()
    root.factory = SqlNodeFactory.initialize()
    return root
  }
}
