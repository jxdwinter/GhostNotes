import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Meeting.date, order: .reverse) private var meetings: [Meeting]

    var body: some View {
        TabView {
            RecordingView()
                .tabItem {
                    Label("Record", systemImage: "waveform")
                }
            MinutesListView()
                .tabItem {
                    Label("Minutes", systemImage: "doc.text.magnifyingglass")
                }
        }
        .tint(GhostTheme.lavender)
        .task {
            seedSampleDataIfNeeded()
        }
    }

    private func seedSampleDataIfNeeded() {
        guard meetings.isEmpty else { return }

        let firstAction = ActionItem(
            title: "Prepare onboarding notes",
            owner: "Maya",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: .now)
        )
        let secondAction = ActionItem(
            title: "Review the recording flow",
            owner: "Alex",
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: .now)
        )
        let minutes = Minutes(
            summary: "The team aligned on the first GhostNotes prototype and clarified the next review steps.",
            decisions: [
                "Ship the first prototype next Friday.",
                "Review the recording flow before the next meeting."
            ],
            actionItems: [firstAction, secondAction]
        )
        let meeting = Meeting(
            title: "GhostNotes prototype kickoff",
            transcriptText: "The team agreed to ship the first GhostNotes prototype next Friday."
        )
        meeting.minutes = minutes
        minutes.meeting = meeting
        firstAction.minutes = minutes
        secondAction.minutes = minutes

        modelContext.insert(meeting)
        modelContext.insert(minutes)
        modelContext.insert(firstAction)
        modelContext.insert(secondAction)
        try? modelContext.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Meeting.self, Minutes.self, ActionItem.self], inMemory: true)
}
