public protocol SingleNodeSearchable {
  func get(from start: SqlNode) -> SqlNode?
}
