import SwiftData
import SwiftUI

struct MinutesListView: View {
    @Query(sort: \Minutes.createdAt, order: .reverse) private var minutes: [Minutes]

    var body: some View {
        NavigationStack {
            Group {
                if minutes.isEmpty {
                    ContentUnavailableView(
                        "No minutes yet",
                        systemImage: "doc.text",
                        description: Text("Record a meeting to create your first set of minutes.")
                    )
                } else {
                    List(minutes) { minutes in
                        NavigationLink {
                            MinutesDetailView(minutes: minutes)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(minutes.meeting?.title ?? "Untitled meeting")
                                    .font(.headline)
                                    .foregroundStyle(GhostTheme.ghostWhite)
                                Text(minutes.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(GhostTheme.mist)
                                    .lineLimit(2)
                                Label("\(minutes.actionItems.count) action items", systemImage: "checklist")
                                    .font(.caption)
                                    .foregroundStyle(GhostTheme.lavender)
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(GhostTheme.surface)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Minutes")
            .ghostBackground()
        }
    }
}

#Preview {
    MinutesListView()
        .modelContainer(for: [Meeting.self, Minutes.self, ActionItem.self], inMemory: true)
}
