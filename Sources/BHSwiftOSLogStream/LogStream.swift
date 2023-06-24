//
// Created by Brian Henry on 2/24/23.
//

import Foundation


open class LogStream {

    let delegate: LogStreamDelegateProtocol

    let logParser: LogParser

    var history: History<LogEntry>

    public init(subsystem: String, delegate: LogStreamDelegateProtocol, historySize: Int? = nil) {
        self.delegate = delegate
        logParser = LogParser()
        history = History<LogEntry>(maxSize: historySize)
        listen(subsystem: subsystem)
    }

    public init(process: String, delegate: LogStreamDelegateProtocol, historySize: Int? = nil) {
        self.delegate = delegate
        logParser = LogParser()
        history = History<LogEntry>(maxSize: historySize)
        listen(process: process)
    }

    // /usr/bin/log stream --predicate 'subsystem == "com.apple.TimeMachine"' --info
    private func listen(subsystem: String? = nil, process: String? = nil) {

        DispatchQueue.global().async {

            let pipe = Pipe()

            let executeCommandProcess = Process()

            executeCommandProcess.standardOutput = pipe

            executeCommandProcess.launchPath = "/usr/bin/log"

            var args = [
                "stream",
                "--info", // log level
            ]

            if let subsystem = subsystem {
                let predicate = NSPredicate(format: "subsystem == %@", subsystem)
                args.append("--predicate")
                args.append(predicate.predicateFormat)
            }

            if let process = process {
                args.append("--process")
                args.append(process)
            }

            // `--info` is "minimum" log level, I think. i.e. this returns info and error etc.
            executeCommandProcess.arguments = args

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
            // Every log stream begins with a line like:
            // Filtering the log data using "subsystem == "com.apple.TimeMachine""
            if logLine.starts(with: "Filtering the log data") {
                return;
            }
            print("Could not parse line:\n\n\(logLine)")
            return
        }

        history.append(item: logLineEntry)

        DispatchQueue.main.async {
            self.delegate.newLogEntry(entry: logLineEntry, history: self.history)
        }
    }

}
