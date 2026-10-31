import EventKit
import Foundation

protocol Exporting {
    func markdown(for minutes: Minutes) -> String
}

struct ExportService: Exporting {
    private let dateFormatter: DateFormatter

    init() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateFormatter = formatter
    }

    func markdown(for minutes: Minutes) -> String {
        var output = "# Meeting Minutes\n\n"
        output += "## Summary\n\n\(minutes.summary)\n\n"
        output += "## Decisions\n\n"
        if minutes.decisions.isEmpty {
            output += "- None recorded\n\n"
        } else {
            output += minutes.decisions.map { "- \($0)" }.joined(separator: "\n") + "\n\n"
        }
        output += "## Action Items\n\n"
        if minutes.actionItems.isEmpty {
            output += "- None recorded\n"
        } else {
            output += minutes.actionItems.map { actionItem in
                let checkbox = actionItem.isDone ? "x" : " "
                var line = "- [\(checkbox)] \(actionItem.title) — Owner: \(actionItem.owner)"
                if let dueDate = actionItem.dueDate {
                    line += " — Due: \(dateFormatter.string(from: dueDate))"
                }
                return line
            }.joined(separator: "\n") + "\n"
        }
        return output
    }
}

protocol ReminderExporting {
    func addToReminders(_ actionItems: [ActionItem]) async throws
}

/// EventKit boundary for the follow-up action-item Reminders integration.
final class EventKitReminderService: ReminderExporting {
    private let eventStore = EKEventStore()

    func addToReminders(_ actionItems: [ActionItem]) async throws {
        guard try await eventStore.requestFullAccessToReminders() else { return }
        for actionItem in actionItems {
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = actionItem.title
            reminder.notes = "Owner: \(actionItem.owner)"
            reminder.isCompleted = actionItem.isDone
            if let dueDate = actionItem.dueDate {
                reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dueDate)
            }
            try eventStore.save(reminder, commit: true)
        }
    }
}
