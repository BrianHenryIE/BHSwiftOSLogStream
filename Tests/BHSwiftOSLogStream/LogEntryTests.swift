//
// Created by Brian Henry on 2/24/23.
//

@testable import BHSwiftOSLogStream

import XCTest


final class LogEntryTests: XCTestCase {

    func testEnum() throws {

        let result = LogEntry.LogType(rawValue: "Info")

        XCTAssertEqual(LogEntry.LogType.Info, result)
    }



    func testAllDescriptions() throws {

        throw XCTSkip()

        // Date parsing precision isn't good enough
        // https://stackoverflow.com/a/23685280/336146

        for n in 1..<52 {
            try! message(number: n)
        }
    }

    func message(number: Int) throws {

        let bundle = Bundle.module

        let str = String(number)
        let paddingZero = String(repeating: "0", count: 3 - str.count)

        guard let path = bundle.path(forResource: "message\(paddingZero)\(number)", ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            continueAfterFailure = false
            XCTFail("File error: message\(paddingZero)\(number)")
            return
        }

        let sut = LogParser()

        let parsedLog = sut.parse(logLine: content)!

        let result = "\(parsedLog)"

        XCTAssertEqual(content, result)
    }

}
