//
// Created by Brian Henry on 2/27/23.
//

@testable import BHSwiftOSLogStream

import XCTest

final class UIntHexTests: XCTestCase {

    func testUnPrefixed() throws {

        let result = UInt64(fromHex: "11c01")

        XCTAssertEqual(72705, result!)
    }

    func testPrefixed() throws {

        let result =  UInt64(fromHex: "0x11c01")

        XCTAssertEqual(72705, result!)
    }

    func testAsHex() throws {

        let uint64Val = UInt64(fromHex: "0x11c01")

        let result = uint64Val!.asHex()

        XCTAssertEqual("0x11c01", result)
    }

    func testCompareString() {
        let uint64Val =  UInt64(fromHex: "0x11c01")!

        let isEqual = "0x11C01" == uint64Val

        XCTAssertTrue( isEqual )
    }

    func testCompareStringNotEqual() {
        let uint64Val =  UInt64(fromHex: "0x11c01")!

        let isEqual = "0xFF" == uint64Val

        XCTAssertFalse( isEqual )
    }


}
