import Foundation
import Speech

protocol TranscriptionService {
    func transcribe(audioFileReference: String?) async throws -> String
}

struct MockTranscriptionService: TranscriptionService {
    let sampleTranscript = "The team agreed to ship the first GhostNotes prototype next Friday. Maya will prepare the onboarding notes, and Alex will review the recording flow before the next meeting."

    func transcribe(audioFileReference: String?) async throws -> String {
        sampleTranscript
    }
}

enum TranscriptionError: LocalizedError {
    case onDeviceRecognitionUnavailable
    case implementationPending

    var errorDescription: String? {
        switch self {
        case .onDeviceRecognitionUnavailable:
            "On-device Speech recognition is unavailable for this device."
        case .implementationPending:
            "Live audio recognition will be connected in a follow-up implementation."
        }
    }
}

/// The Apple Speech integration boundary for a future AVAudioEngine implementation.
final class OnDeviceTranscriptionService: TranscriptionService {
    private let recognizer: SFSpeechRecognizer?

    init(locale: Locale = .current) {
        recognizer = SFSpeechRecognizer(locale: locale)
    }

    func transcribe(audioFileReference: String?) async throws -> String {
        guard recognizer?.supportsOnDeviceRecognition == true else {
            throw TranscriptionError.onDeviceRecognitionUnavailable
        }
        throw TranscriptionError.implementationPending
    }
}
