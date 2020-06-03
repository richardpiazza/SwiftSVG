import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SVGTests.allTests),
        testCase(TransformationTests.allTests),
    ]
}
#endif
