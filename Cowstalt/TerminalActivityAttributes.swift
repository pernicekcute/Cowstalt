import ActivityKit
import Foundation

public struct TerminalActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var terminalText: String
        
        // Explicit public initializer for ContentState
        public init(terminalText: String) {
            self.terminalText = terminalText
        }
    }
    
    public var sessionName: String
    
    // Explicit public initializer for TerminalActivityAttributes
    public init(sessionName: String) {
        self.sessionName = sessionName
    }
}
