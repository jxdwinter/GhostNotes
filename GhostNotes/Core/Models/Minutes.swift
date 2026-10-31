import Foundation
import SwiftData

@Model
final class Minutes {
    var id: UUID
    var summary: String
    var decisions: [String]
    var createdAt: Date
    var meeting: Meeting?
    @Relationship(deleteRule: .cascade, inverse: \ActionItem.minutes)
    var actionItems: [ActionItem]

    init(
        id: UUID = UUID(),
        summary: String,
        decisions: [String] = [],
        actionItems: [ActionItem] = [],
        createdAt: Date = .now,
        meeting: Meeting? = nil
    ) {
        self.id = id
        self.summary = summary
        self.decisions = decisions
        self.actionItems = actionItems
        self.createdAt = createdAt
        self.meeting = meeting
    }
}
