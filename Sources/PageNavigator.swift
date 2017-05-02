public class PageNavigator {
    public var totalCount = 0
    public var previousPage = 1
    public var nextPage = 1
    public var currentPage: Int {
      get {
        return self.currentPage
      }
      set(currentPage) {
        var cp = currentPage
        if currentPage <= 1 {
          previousPage = 1
          cp = 1
        } else {
          previousPage = currentPage - 1
        }
        if currentPage >= totalPageCount {
          nextPage = totalPageCount
          cp = totalPageCount
        } else {
          nextPage = currentPage + 1
        }
        self.currentPage = cp
      }
    }
    public var totalPageCount = 1
    public var countPerPage = 10

    init() {}
    
    init(totalCount: Int, countPerPage: Int) {
      self.totalCount = totalCount
      self.countPerPage = countPerPage
      countPageSize()
      currentPage = 1
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
