protocol Joinable {
  func on() -> On
  func on(_ conditions: [String]) -> Joinable
}

extension Joinable {
  public func on(_ conditions: [String]) -> Joinable {
    let on = self.on()
    for c in conditions {
      _ = on.and(c)
    }
    return self
  }
}
