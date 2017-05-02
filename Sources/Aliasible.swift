public protocol Aliasible: class {
  var alias: String { get set }
  func `as`(with alias: String)
}
public protocol SelfAliasible: Aliasible {
  associatedtype Me
  func `as`(_ alias: String) -> Me
}
// providing default implementation to change self alias property(state)
extension SelfAliasible {
  public func `as`(with alias: String) {
    self.alias = alias
  }
  public func `as`(_ alias: String) -> Me {
    `as`(with: alias)
    return self as! Me
  }
}
