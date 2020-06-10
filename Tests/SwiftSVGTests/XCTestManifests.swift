import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        textCase(CommandRepresentableTests.allTests),
        testCase(PathDataTests.allTests),
        testCase(SVGTests.allTests),
        testCase(TransformationTests.allTests),
    ]
}
#endif
