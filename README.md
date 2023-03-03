# Swift OS Log Stream

> ⚠️ Use [OSLogStore](https://developer.apple.com/documentation/oslog/oslogstore) instead.

Opens a `/usr/bin/log stream` `Process` and parses data sent to the `Pipe` via its `readabilityHandler` with `Regex`.

Instantiate a `LogStream`'s:

`init(subsystem: String, delegate: LogStreamDelegateProtocol, historySize: Int? = nil)`

where `subsystem` is e.g. "com.apple.TimeMachine", `LogStreamDelegateProtocol` is:

`func newLogEntry(entry: LogEntry, history: History<LogEntry>)`

and `History` is a FIFO queue of the specified length, or `nil` for infinite length.

The previous logs are returned since the event indicated by the current log entry might desire data from other recent entries. E.g. when a Time Machine backup completes, that event does not contain the volume name, but it will be in a recent log entry.

### Requires Admin Access

I believe any apps built with this will require admin access to read `/usr/bin/log`.

New XCode apps include the [App Sandbox](https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox) capability which must be removed – under the target's "signing and capabilities".

### Possible Improvements

* [Logging in Swift](https://steipete.com/posts/logging-in-swift/) article on [steipete.com](http://steipete.com) suggests using `OSLogStore` but I had already written this much before I saw that.
* StackOverflow user [Vadian](https://stackoverflow.com/users/5044042/vadian), in [Event notifications in macOS](https://stackoverflow.com/questions/54927655/event-notifications-in-macos), suggests using `DistributedNotificationCenter` for Time Machine (my use case). 
* Filtering the logs could be implemented via predicates, see: [log: a primer on predicates](https://eclecticlight.co/2016/10/17/log-a-primer-on-predicates/) on the great [The Eclectic Light Company](https://eclecticlight.co) website.
* Parsing could be much lazier.

### Further Reading

* https://developer.apple.com/documentation/os/os_log
* https://developer.apple.com/documentation/os/logging/viewing_log_messages
* https://developer.apple.com/videos/play/wwdc2020/10168/