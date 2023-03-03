//
// Created by Brian Henry on 2/27/23.
//

import Foundation

extension UInt64 {

    init?(fromHex: String) {

        var fromHex = fromHex

        if fromHex.hasPrefix("0x") {
            fromHex = String(fromHex.dropFirst("0x".count))
        }

        guard let asInt = UInt64(fromHex, radix: 16) else {
            return nil
        }

        self.init(asInt)
    }

    func asHex() -> String {
        "0x" + String(format: "%01x", self)
    }

    static func == (lhs: String, rhs: UInt64) -> Bool {
        guard let uintLhs = UInt64(fromHex: lhs) else {
            return false
        }
        return uintLhs == rhs
    }

}