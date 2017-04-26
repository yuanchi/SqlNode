import XCTest
@testable import SqlNodeTests

XCTMain([
    testCase(SqlNodeTests.allTests),
    testCase(RootNodeTests.allTests),
    testCase(SimpleExpressionTests.allTests),
    testCase(SimpleConditionTests.allTests),
    testCase(TargetExpressibleTests.allTests),
    testCase(SelectExpressionTests.allTests),
    testCase(FromTests.allTests)
])
