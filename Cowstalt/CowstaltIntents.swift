import AppIntents
import ActivityKit

struct StartCowstaltActivityIntent: AppIntent {
    // This is the name of the block that appears in the Shortcuts app
    static var title: LocalizedStringResource = "Start Cowstalt Terminal"
    
    // Description under the block
    static var description = IntentDescription("Launches the Cowstalt terminal LiveActivity with multiple lines.")

    // Parameter array so users can click '+' to add multiple terminal lines
    @Parameter(
        title: "Terminal Line",
        description: "Add lines to display in the terminal Live Activity."
    )
    var terminalLines: [String]

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

        // Combine all entered lines into a single multi-line string
        let combinedText = terminalLines.joined(separator: "\n")

        let attributes = TerminalActivityAttributes(sessionName: "CowstaltSession")
        let initialState = TerminalActivityAttributes.ContentState(terminalText: combinedText)

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
