//
// Created by Brian Henry on 2/24/23.
//

import Foundation
import OSLog

// OSLogEntry

public struct LogEntry: CustomStringConvertible {

    public init( timestamp: Date, thread: UInt64, logType: LogEntry.LogType, activity: UInt64, pid: UInt, context: String, ttl: UInt, namespace: LogEntry.NameSpace,message: String ) {
        self.timestamp = timestamp
        self.thread=thread
        self.logType=logType
        self.activity=activity
        self.pid=pid
        self.context=context
        self.ttl=ttl
        self.namespace=namespace
        self.message=message
    }

    // os_log_type_t
    public enum LogType: String {
        case Debug = "Debug"
        case Info = "Info"
        case Default = "Default"
        case Error = "Error"
        case Fault = "Fault"
    }

    public struct NameSpace {
        public init(namespace: String, namespaceContext: String? ) {
            self.namespace = namespace
            self.namespaceContext = namespaceContext
        }

        let namespace: String
        let namespaceContext: String?
    }

    public let timestamp: Date

    public let thread: UInt64

    public let logType: LogEntry.LogType

    public let activity: UInt64

    public let pid: UInt

    public let context: String

    public let ttl: UInt

    public let namespace: LogEntry.NameSpace

    public let message: String

    public var description: String {
        var descriptionString = ""

        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:mm:ss.SSSSSSZ"
        descriptionString += df.string(from: timestamp)
        descriptionString += " "
        descriptionString += thread.asHex().padding(toLength: 11, withPad: " ", startingAt: 0)
        descriptionString += logType.rawValue.padding(toLength: 12, withPad: " ", startingAt: 0)
        descriptionString += activity.asHex().padding(toLength: 21, withPad: " ", startingAt: 0)
        descriptionString += pid.description.padding(toLength: 7, withPad: " ", startingAt: 0)
        descriptionString += ttl.description.padding(toLength: 5, withPad: " ", startingAt: 0)
        descriptionString += context
        descriptionString += " ["
        descriptionString += namespace.namespace
        descriptionString += ":"
        descriptionString += namespace.namespaceContext ?? ""
        descriptionString += "] "
        descriptionString += message

        return descriptionString
    }
}
