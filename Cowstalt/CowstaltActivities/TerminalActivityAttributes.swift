import ActivityKit
import Foundation

public struct TerminalActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var terminalText: String
    }
    public var sessionName: String
}
