import Foundation

enum PreviewScenario: String {
    case today, history, trends, detail, session, add, settings

    static var current: Self? {
        #if DEBUG
        ProcessInfo.processInfo.environment["MOTION_PREVIEW_SCREEN"].flatMap(Self.init(rawValue:))
        #else
        nil
        #endif
    }
}
