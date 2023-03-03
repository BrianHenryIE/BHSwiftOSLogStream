//
// Created by Brian Henry on 2/24/23.
//

import Foundation


open class LogStream {

    let delegate: LogStreamDelegateProtocol

    let logParser: LogParser

    var history: History<LogEntry>

    init(subsystem: String, delegate: LogStreamDelegateProtocol, historySize: Int? = nil) {
        self.delegate = delegate
        logParser = LogParser()
        history = History<LogEntry>(maxSize: historySize)
        listen(subsystem: subsystem)
    }

    // /usr/bin/log stream --predicate 'subsystem == "com.apple.TimeMachine"' --info
    private func listen(subsystem: String) {

        DispatchQueue.global().async {

            let pipe = Pipe()

            let executeCommandProcess = Process()

            executeCommandProcess.standardOutput = pipe

            executeCommandProcess.launchPath = "/usr/bin/log"

            let predicate = NSPredicate(format: "subsystem == %@", subsystem)

            // `--info` is "minimum" log level, I think. i.e. this returns info and error etc.
            executeCommandProcess.arguments = ["stream", "--info", "--predicate", predicate.predicateFormat]

            pipe.fileHandleForReading.readabilityHandler = self.handler

            executeCommandProcess.launch()

            executeCommandProcess.waitUntilExit()
        }
    }

    func handler(fileHandle: FileHandle) -> Void {
        let availableData = fileHandle.availableData
        guard let logLine = String.init(data: availableData, encoding: .utf8) else {
            return
        }

        guard let logLineEntry = self.logParser.parse(logLine: logLine) else {
            print("Could not parse line:\n\n\(logLine)")
            return
        }

        history.append(item: logLineEntry)

        DispatchQueue.main.async {
            self.delegate.newLogEntry(entry: logLineEntry, history: self.history)
        }
    }

}
