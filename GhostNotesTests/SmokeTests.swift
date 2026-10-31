import Foundation
import Testing
@testable import GhostNotes

struct SmokeTests {
    @Test
    func modelCreationStoresMeetingAndMinutes() {
        let actionItem = ActionItem(title: "Review transcript", owner: "Alex")
        let minutes = Minutes(
            summary: "A focused project update.",
            decisions: ["Continue with the prototype."],
            actionItems: [actionItem]
        )
        let meeting = Meeting(title: "Weekly sync", transcriptText: "A project update.", minutes: minutes)
        minutes.meeting = meeting
        actionItem.minutes = minutes

        #expect(meeting.title == "Weekly sync")
        #expect(meeting.minutes?.summary == "A focused project update.")
        #expect(minutes.actionItems.first?.owner == "Alex")
    }

    @Test
    func minutesFormattingContainsStructuredSections() {
        let minutes = Minutes(
            summary: "The team aligned on scope.",
            decisions: ["Ship the prototype."],
            actionItems: [ActionItem(title: "Write onboarding notes", owner: "Maya")]
        )
        let markdown = ExportService().markdown(for: minutes)

        #expect(markdown.contains("## Summary"))
        #expect(markdown.contains("## Decisions"))
        #expect(markdown.contains("## Action Items"))
    }

    @Test
    func exportMarkdownIncludesActionOwner() {
        let minutes = Minutes(
            summary: "Summary",
            actionItems: [ActionItem(title: "Review recording", owner: "Alex")]
        )
        let markdown = ExportService().markdown(for: minutes)

        #expect(markdown.contains("Review recording"))
        #expect(markdown.contains("Owner: Alex"))
    }
}
