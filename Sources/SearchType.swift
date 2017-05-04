public enum SearchType: SingleNodeSearchable {
  case expression(String)
  case id(String)
  case alias(String)

  public func get(from start: SqlNode) -> SqlNode? {
    var found: SqlNode? = nil
    switch self {
    case .id(let val):
      found = start.findFirst { n in
        if let casted = n as? Identifiable {
          return casted.id == val
        }
        return false
      } as? SqlNode
    case .alias(let val):
      found = start.findFirst { n in
        if let casted = n as? Aliasible {
          return casted.alias == val
        }
        return false
      } as? SqlNode
    case .expression(let val):
      found = start.findFirst { n in
        if let casted = n as? Expressible {
          return casted.expression == val
        }
        return false
      } as? SqlNode
    }
    return found
  }
}
