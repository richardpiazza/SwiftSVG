import Foundation
import Swift2D
@testable import SwiftSVG
import Testing

struct SVGTests {

    @Test func simpleDecode() throws {
        let doc = """
        <?xml version="1.0" encoding="UTF-8"?>
        <svg width="1024px" height="1024px" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1">
         <path id="Padlock" d="M168.044 945 C118.866 945 79 905.133 79 855.956 L79 474.339 C79 425.166 118.866 385.295 168.044 385.295 168.044 385.295 192.485 385.295 232.144 385.295 232.144 271.21 273.793 80 511.5 80 717.82 80 791.775 269.222 791.775 385.295 830.889 385.295 854.955 385.295 854.955 385.295 904.129 385.295 944 425.166 944 474.339 L944 855.956 C944 905.133 904.129 945 854.955 945 L168.044 945 Z M512.295 741.869 C536.854 741.584 536.643 723.198 536.643 686.365 566.441 675.977 587.823 647.61 587.823 614.265 587.823 572.117 553.648 537.941 511.5 537.941 469.347 537.941 435.176 572.117 435.176 614.265 435.176 647.994 455.869 676.624 486.208 686.713 486.208 721.604 486.295 742.174 512.295 741.869 Z M333.734 385.916 L689.588 385.692 689.588 346.736 C689.588 346.736 690.726 181.367 511.897 181.367 333.066 181.367 333.014 349.12 333.014 349.12 L333.734 385.916 Z" fill="none" stroke="#f9e231" stroke-width="20" stroke-opacity="1" stroke-linejoin="round"/>
        </svg>
        """

        let data = try #require(doc.data(using: .utf8))
        let svg = try SVG.make(with: data)

        #expect(svg.outputSize == Size(width: 1024, height: 1024))
        let path = try #require(svg.paths?.first)
        #expect(path.id == "Padlock")
        #expect(!path.data.isEmpty)
        let description = path.description
        #expect(description.hasPrefix("<path"))
    }

    @Test func decode() throws {
        let doc = """
        <svg xmlns="http://www.w3.org/2000/svg" width="2500" height="2500" viewBox="0 0 192.756 192.756">
            <g fill-rule="evenodd" clip-rule="evenodd">
                <path fill="#fff" d="M0 0h192.756v192.756H0V0z"/>
                <path d="M42.154 13.778v26.481c0 4.414-3.153 5.044-6.306 5.044-2.521 0-5.674-.63-5.674-5.044V13.778h4.414v25.851c0 1.892.631 1.892 1.261 1.892 1.261 0 1.892 0 1.892-1.892V13.778h4.413zM54.133 13.778l1.261 8.828c1.261 5.674 1.892 11.979 2.522 17.654v-1.892-24.59H61.7v30.896h-6.936l-1.892-15.763c-1.261-3.783-1.261-6.937-1.892-10.719v26.481h-3.783V13.778h6.936zM66.744 13.778h5.044v30.895h-5.044V13.778zM80.615 13.778l1.262 12.61c.63 3.152.63 9.458 1.261 12.61 0-3.783.63-7.566.63-11.35l1.892-13.871h4.414L86.29 44.673h-6.936l-3.783-30.896h5.044v.001zM94.486 13.778h5.045v30.895h-5.045V13.778zM108.988 39.628c0 1.892.631 1.892 1.262 1.892 1.26 0 1.891 0 1.891-1.892v-3.152c0-4.414-7.564-8.827-7.564-13.871v-4.414c0-4.414 3.15-5.045 5.674-5.045 3.152 0 6.305.631 6.305 5.045v6.305h-4.414v-5.675c0-1.892-.631-2.522-1.891-2.522-.631 0-1.262.63-1.262 2.522v3.784c0 1.891 7.566 8.827 7.566 11.979v5.674c0 4.414-3.152 5.044-6.305 5.044-2.523 0-5.674-.63-5.674-5.044v-6.936h4.412v6.306zM121.6 13.778h4.412v30.895H121.6V13.778zM135.471 18.822c0-1.892.631-2.522 1.891-2.522.631 0 1.262.63 1.262 2.522v20.807c0 1.892-.631 1.892-1.262 1.892-1.26 0-1.891 0-1.891-1.892V18.822zm-4.414 21.437c0 4.414 3.152 5.044 6.305 5.044 2.521 0 5.676-.63 5.676-5.044V18.192c0-4.414-3.154-5.045-5.676-5.045-3.152 0-6.305.631-6.305 5.045v22.067zM155.646 13.778l1.262 8.828c.631 5.674 1.26 11.979 1.891 17.654v-1.892-24.59h3.783v30.896h-6.936l-1.891-15.763c-.631-3.783-1.262-6.937-1.262-10.719h-.631v26.481h-3.783V13.778h7.567z"/>
                <path fill="#649f53" d="M100.16 115.291h62.422V52.239H100.16v63.052z"/>
                <path d="M92.595 115.291c0-34.679-28.374-63.052-62.421-63.052v63.052h62.421z" fill="#6f6ba9"/>
                <path d="M30.174 122.857c0 34.047 27.743 62.422 62.421 62.422v-62.422H30.174z" fill="#c9322d"/>
                <path d="M162.582 122.857c0 34.047-27.742 62.422-62.422 62.422v-62.422h62.422z" fill="#4595d1"/>
            </g>
        </svg>
        """

        let data = try #require(doc.data(using: .utf8))
        let svg = try SVG.make(with: data)
        #expect(svg.outputSize == Size(width: 2500, height: 2500))
    }

    @Test func quad01Decode() throws {
        let url = try #require(Bundle.swiftSVGTests.url(forResource: "quad01", withExtension: "svg"))
        let data = try Data(contentsOf: url)
        let svg = try SVG.make(with: data)
        let path = try #require(svg.paths?.first)
        #expect(path.data == "M200,300 Q400,50 600,300 T1000,300")
        let commands = try path.commands()
        #expect(commands == [
            .moveTo(point: Point(x: 200, y: 300)),
            .quadraticBezierCurve(cp: Point(x: 400, y: 50), point: Point(x: 600, y: 300)),
            .quadraticBezierCurve(cp: Point(x: 800, y: 550), point: Point(x: 1000, y: 300)),
        ])

        let primaryGroup = try #require(svg.groups?.first)
        let primaryPoints = try #require(primaryGroup.circles)
        #expect(primaryPoints.count == 3)

        let secondaryGroup = try #require(svg.groups?.last)
        let secondaryPoints = try #require(secondaryGroup.circles)
        #expect(secondaryPoints.count == 2)
    }
}
