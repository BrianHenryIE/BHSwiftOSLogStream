// A FIFO queue
//
// Because the most recent log often needs the context of previous logs,
//
// Created by Brian Henry on 5/21/22.
//
//

import Foundation

public struct History<T> {

    public let maxSize: Int?

    public private(set) var backingArray = Array<T>()

    public init(maxSize:Int? = nil) {
        self.maxSize = maxSize
    }

    public mutating func append(item: T){

        backingArray.append(item)

        guard let maxSize = maxSize else {
            return
        }

        if( backingArray.count > maxSize ) {
            // Should we use popFirst or removeFirst?
            _ = backingArray.removeFirst()
        }
    }

    // -1 to get last
    public func get(at index: Int = -1) -> T? {

        // |  0 |  1 |  2 |  3 |  4 |  5 |
        // | -6 | -5 | -4 | -3 | -2 | -1 |
        // count = 6

        var vIndex = index

        if( index < 0 ) {
            vIndex = backingArray.count + index
        }

        if( vIndex < 0 || vIndex > backingArray.count ) {
            return nil
        }

        return backingArray[vIndex]
    }
}
