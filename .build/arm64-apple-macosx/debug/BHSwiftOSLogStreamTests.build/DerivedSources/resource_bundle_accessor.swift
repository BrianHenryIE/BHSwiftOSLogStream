import class Foundation.Bundle

extension Foundation.Bundle {
    static let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("BHSwiftOSLogStream_BHSwiftOSLogStreamTests.bundle").path
        let buildPath = "/Users/brianhenry/Sites/BHSwiftOSLogStream/.build/arm64-apple-macosx/debug/BHSwiftOSLogStream_BHSwiftOSLogStreamTests.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}