import AppIntents
import ActivityKit

struct StartCowstaltActivityIntent: LiveActivityIntent {
    // This is the name of the block that appears in the Shortcuts app
    static var title: LocalizedStringResource = "Cowstalt Live Activity"
    
    // Description under the block
    static var description = IntentDescription("Launches the Cowstalt terminal Live Activity with a mandatory first line and optional extra lines.")

    // Mandatory first line (cannot be removed)
    @Parameter(
        title: "Terminal Line 1",
        description: "The primary line that must always be included."
    )
    var terminalLine1: String

    // Optional list of extra lines (users can add or remove these via '+' and '-')
    @Parameter(
        title: "Additional Lines",
        description: "Add or remove extra lines below the first line.",
        default: []
    )
    var additionalLines: [String]

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

        // Combine Line 1 with any additional lines
        let allLines = [terminalLine1] + additionalLines
        let combinedText = allLines.joined(separator: "\n")

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
