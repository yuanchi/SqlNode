public class PageNavigator {
    public var totalCount = 0
    public var previousPage = 1
    public var nextPage = 1
    var current = 1
    public var currentPage: Int {
      get {
        return self.current
      }
      set {
        var currentPage = newValue
        if newValue <= 1 {
          previousPage = 1
          currentPage = 1
        } else {
          previousPage = currentPage - 1
        }
        if newValue >= totalPageCount {
          nextPage = totalPageCount
          currentPage = totalPageCount
        } else {
          nextPage = currentPage + 1
        }
        self.current = currentPage
      }
    }
    public var totalPageCount = 1
    public var countPerPage = 10
    public var offset: Int {
      return countPerPage * (currentPage - 1)
    }

    init() {}

    init(totalCount: Int, countPerPage: Int) {
      self.totalCount = totalCount
      self.countPerPage = countPerPage
      countPageSize()
    }

    public func countPageSize() {
      if totalCount == 0 {
        totalPageCount = 1
      } else {
        totalPageCount = totalCount / countPerPage
        if totalCount % countPerPage != 0 {
          totalPageCount += 1
        }
      }
    }
}
