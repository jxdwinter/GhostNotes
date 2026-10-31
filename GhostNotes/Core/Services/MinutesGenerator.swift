import Foundation

protocol MinutesGenerating {
    func generateMinutes(from transcript: String) async throws -> MinutesDraft
}

struct MinutesDraft {
    let summary: String
    let decisions: [String]
    let actionItems: [ActionItemDraft]
}

struct ActionItemDraft {
    let title: String
    let owner: String
    let dueDate: Date?
}

struct StubMinutesGenerator: MinutesGenerating {
    func generateMinutes(from transcript: String) async throws -> MinutesDraft {
        MinutesDraft(
            summary: "The team aligned on the first GhostNotes prototype and clarified the next review steps.",
            decisions: [
                "Ship the first prototype next Friday.",
                "Review the recording flow before the next meeting."
            ],
            actionItems: [
                ActionItemDraft(title: "Prepare onboarding notes", owner: "Maya", dueDate: Calendar.current.date(byAdding: .day, value: 3, to: .now)),
                ActionItemDraft(title: "Review the recording flow", owner: "Alex", dueDate: Calendar.current.date(byAdding: .day, value: 5, to: .now))
            ]
        )
    }
}

enum MinutesGeneratorError: LocalizedError {
    case apiCallNotImplemented

    var errorDescription: String? {
        "The Gemini request skeleton is present, but network generation is out of scope for this scaffold."
    }
}

/// Configuration-ready Gemini seam. The scaffold intentionally uses StubMinutesGenerator at runtime.
struct GeminiMinutesGenerator: MinutesGenerating {
    private let apiKey: String?

    init(apiKey: String? = ProcessInfo.processInfo.environment["GEMINI_API_KEY"]) {
        self.apiKey = apiKey
    }

    func generateMinutes(from transcript: String) async throws -> MinutesDraft {
        _ = apiKey
        _ = transcript
        throw MinutesGeneratorError.apiCallNotImplemented
    }
}
