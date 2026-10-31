import Foundation
import SwiftData

@Model
final class ActionItem {
    var id: UUID
    var title: String
    var owner: String
    var dueDate: Date?
    var isDone: Bool
    var minutes: Minutes?

    init(
        id: UUID = UUID(),
        title: String,
        owner: String,
        dueDate: Date? = nil,
        isDone: Bool = false,
        minutes: Minutes? = nil
    ) {
        self.id = id
        self.title = title
        self.owner = owner
        self.dueDate = dueDate
        self.isDone = isDone
        self.minutes = minutes
    }
}
