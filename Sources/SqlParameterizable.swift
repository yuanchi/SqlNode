protocol SqlParameterizable {}

protocol SingleParameterizable: SqlParameterizable{
  var param: SqlParameter? { get set }
  var paramVal: Any? { get set }
}

extension SingleParameterizable {
  var paramVal: Any? {
    get {
      return param?.val
    }
    set {
      if let p = self.param {
        p.val = newValue
      }
    }
  }
}
