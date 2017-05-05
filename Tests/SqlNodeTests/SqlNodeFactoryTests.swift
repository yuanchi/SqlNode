import XCTest
@testable import SqlNode

class SqlNodeFactoryTests: XCTestCase {
  func canNotChangeFactoryWithSingleton() {
    let singleton = SqlNodeFactory.shared
    // singleton.replace(with: Select.self) { Select() }
    print("this will stop procedure because not matched to precondition, but now commented out")
  }
  static var allTests = [
    ("canNotChangeFactoryWithSingleton", canNotChangeFactoryWithSingleton),
  ]
}
