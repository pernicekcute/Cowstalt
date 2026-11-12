import ActivityKit
import SwiftUI
import WidgetKit
import AppIntents

// 1. Define the AppIntent to stop the Live Activity
struct StopActivityIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Terminal Activity"

    func perform() async throws -> some IntentResult {
        // End all active instances of this specific Live Activity
        for activity in Activity<TerminalActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        return .result()
    }
}

@main
struct TerminalLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TerminalActivityAttributes.self) { context in
            // Lock Screen / Banner Presentation
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Circle().fill(Color.red).frame(width: 8, height: 8)
                    Circle().fill(Color.yellow).frame(width: 8, height: 8)
                    Circle().fill(Color.green).frame(width: 8, height: 8)
                    Spacer()
                }
                .padding(.bottom, 2)

                Text("Cowstalt")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.gray)

                Text("> \(context.state.terminalText)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.black)
            .activityBackgroundTint(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded Presentation
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Text(context.state.terminalText)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        // Stop Button with 'X' symbol
                        Button(intent: StopActivityIntent()) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 4)
                }
            } compactLeading: {
                Text("$").font(.system(size: 12, design: .monospaced)).foregroundColor(.green)
            } compactTrailing: {
                Image(systemName: "terminal").foregroundColor(.green)
            } minimal: {
                Image(systemName: "terminal").foregroundColor(.green)
            }
            // Adds a green outline/border around the expanded Dynamic Island
            .keylineTint(.green)
        }
    }
}
