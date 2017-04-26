protocol Junctible {
  var junction: Junction { get set }
  func prefixJunction() -> String
}

extension Junctible {
  public func prefixJunction() -> String {
    return junction.rawValue + " "
  }
}
