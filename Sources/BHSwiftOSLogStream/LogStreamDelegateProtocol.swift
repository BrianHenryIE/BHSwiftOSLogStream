//
// Created by Brian Henry on 2/24/23.
//

import Foundation

public protocol LogStreamDelegateProtocol {

    func newLogEntry(entry: LogEntry, history: History<LogEntry>)
}