import XCTest
@testable import SwiftSVG
import Swift2D

final class SVGTests: XCTestCase {
    
    static var allTests = [
        ("testSimpleDecode", testSimpleDecode),
    ]
    
    func testSimpleDecode() throws {
        let doc = """
        <?xml version="1.0" encoding="UTF-8"?>
        <svg width="1024px" height="1024px" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1">
         <path id="Padlock" d="M168.044 945 C118.866 945 79 905.133 79 855.956 L79 474.339 C79 425.166 118.866 385.295 168.044 385.295 168.044 385.295 192.485 385.295 232.144 385.295 232.144 271.21 273.793 80 511.5 80 717.82 80 791.775 269.222 791.775 385.295 830.889 385.295 854.955 385.295 854.955 385.295 904.129 385.295 944 425.166 944 474.339 L944 855.956 C944 905.133 904.129 945 854.955 945 L168.044 945 Z M512.295 741.869 C536.854 741.584 536.643 723.198 536.643 686.365 566.441 675.977 587.823 647.61 587.823 614.265 587.823 572.117 553.648 537.941 511.5 537.941 469.347 537.941 435.176 572.117 435.176 614.265 435.176 647.994 455.869 676.624 486.208 686.713 486.208 721.604 486.295 742.174 512.295 741.869 Z M333.734 385.916 L689.588 385.692 689.588 346.736 C689.588 346.736 690.726 181.367 511.897 181.367 333.066 181.367 333.014 349.12 333.014 349.12 L333.734 385.916 Z" fill="none" stroke="#f9e231" stroke-width="20" stroke-opacity="1" stroke-linejoin="round"/>
        </svg>
        """
        
        let data = try XCTUnwrap(doc.data(using: .utf8))
        let svg = try SVG.make(with: data)
        
        XCTAssertEqual(svg.outputSize, Size(width: 1024, height: 1024))
        let path = try XCTUnwrap(svg.paths?.first)
        XCTAssertEqual(path.id, "Padlock")
        XCTAssertFalse(path.data.isEmpty)
        let description = path.description
        XCTAssertTrue(description.hasPrefix("<path"))
    }
}
