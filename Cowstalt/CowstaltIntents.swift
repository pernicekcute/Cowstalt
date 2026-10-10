import AppIntents
import ActivityKit

struct StartCowstaltActivityIntent: AppIntent {
    // This is the name of the block that appears in the Shortcuts app
    static var title: LocalizedStringResource = "Start Cowstalt Terminal"
    
    // Description under the block
    static var description = IntentDescription("Launches the Cowstalt terminal Live Activity.")

    // Parameter field so you can type or pass custom text into the block
    @Parameter(title: "Terminal Text", default: "")
    var terminalText: String

    // This runs when you execute the shortcut block
    @MainActor
    func perform() async throws -> some IntentResult {
        // Prevent launching duplicate active sessions
        if Activity<TerminalActivityAttributes>.activities.contains(where: { $0.activityState == .active }) {
            return .result()
        }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return .result()
        }

        let attributes = TerminalActivityAttributes(sessionName: "CowstaltSession")
        let initialState = TerminalActivityAttributes.ContentState(terminalText: terminalText)

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity via Shortcut: \(error.localizedDescription)")
        }

        return .result()
    }
}
