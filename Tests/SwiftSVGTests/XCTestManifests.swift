import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CommandRepresentableTests.allTests),
        testCase(PathDataTests.allTests),
        testCase(SVGTests.allTests),
        testCase(TransformationTests.allTests),
    ]
}
#endif
