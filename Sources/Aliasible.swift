public protocol Aliasible {
  var alias: String { get set }
  mutating func `as`(with alias: String)
}
public protocol SelfAliasible: Aliasible {
  associatedtype Me
  mutating func `as`(_ alias: String) -> Me
}
// providing default implementation to change self alias property(state)
extension SelfAliasible {
  mutating public func `as`(with alias: String) {
    self.alias = alias
  }
  mutating public func `as`(_ alias: String) -> Me {
    `as`(with: alias)
    return self as! Me
  }
}
