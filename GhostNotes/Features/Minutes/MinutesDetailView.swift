import SwiftUI

struct MinutesDetailView: View {
    let minutes: Minutes
    private let exportService = ExportService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                section("Summary", systemImage: "text.quote") {
                    Text(minutes.summary)
                        .foregroundStyle(GhostTheme.mist)
                }

                section("Decisions", systemImage: "checkmark.seal") {
                    if minutes.decisions.isEmpty {
                        Text("No decisions recorded.")
                            .foregroundStyle(GhostTheme.mist)
                    } else {
                        ForEach(Array(minutes.decisions.enumerated()), id: \.offset) { _, decision in
                            Label(decision, systemImage: "checkmark")
                                .foregroundStyle(GhostTheme.mist)
                        }
                    }
                }

                section("Action items", systemImage: "checklist") {
                    if minutes.actionItems.isEmpty {
                        Text("No action items recorded.")
                            .foregroundStyle(GhostTheme.mist)
                    } else {
                        ForEach(minutes.actionItems) { actionItem in
                            actionItemRow(actionItem)
                        }
                    }
                }

                section("Markdown preview", systemImage: "doc.plaintext") {
                    Text(markdown)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(GhostTheme.mist)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(GhostTheme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    ShareLink(item: markdown, preview: SharePreview("GhostNotes Minutes")) {
                        Label("Share Markdown", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(GhostTheme.pumpkin)
                }
            }
            .padding(20)
        }
        .navigationTitle("Meeting detail")
        .navigationBarTitleDisplayMode(.inline)
        .ghostBackground()
    }

    private var markdown: String {
        exportService.markdown(for: minutes)
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(GhostTheme.ghostWhite)
            content()
        }
        .padding()
        .background(GhostTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func actionItemRow(_ actionItem: ActionItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: actionItem.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(actionItem.isDone ? GhostTheme.lavender : GhostTheme.mist)
            VStack(alignment: .leading, spacing: 4) {
                Text(actionItem.title)
                    .foregroundStyle(GhostTheme.ghostWhite)
                Text("Owner: \(actionItem.owner)")
                    .font(.caption)
                    .foregroundStyle(GhostTheme.mist)
                if let dueDate = actionItem.dueDate {
                    Text("Due \(dueDate, format: .dateTime.month().day().year())")
                        .font(.caption)
                        .foregroundStyle(GhostTheme.lavender)
                }
            }
        }
    }
}

#Preview {
    let minutes = Minutes(
        summary: "The team aligned on a focused first release.",
        decisions: ["Ship the prototype next Friday."],
        actionItems: [ActionItem(title: "Prepare notes", owner: "Maya")]
    )
    return NavigationStack {
        MinutesDetailView(minutes: minutes)
    }
}
