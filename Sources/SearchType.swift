public enum SearchType {
  case expression(String)
  case id(String)
  case alias(String)

  public var val: String {
    switch self {
    case .id(let v):
        return v
    case .alias(let v):
        return v
    case .expression(let v):
        return v
    }
  }
}
