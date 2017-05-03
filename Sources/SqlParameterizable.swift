protocol SqlParameterizable {}

protocol SingleParameterizable: SqlParameterizable {
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

protocol MultiParameterizable: class, SqlParameterizable {
  var params: [SqlParameter] { get set }
  subscript(idx: Int) -> Any? { get set }
  func addParamVal(_ val: Any) -> MultiParameterizable
}

extension MultiParameterizable {
  subscript(idx: Int) -> Any? {
    get {
      guard idx < params.endIndex else {
        return nil
      }
      return params[idx].val
    }
    set {
      params[idx].val = newValue
    }
  }
  func addParamVal(_ val: Any) -> MultiParameterizable {
    let param = SqlParameter()
    param.val = val
    params.append(param)
    return self
  }
}
