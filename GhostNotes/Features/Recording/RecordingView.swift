import SwiftData
import SwiftUI

private enum RecordingPhase {
    case ready
    case recording
    case recorded
    case transcribed
    case generated
}

struct RecordingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var recordingService = MockAudioRecordingService()
    @State private var phase: RecordingPhase = .ready
    @State private var transcript = ""
    @State private var statusMessage = "Ready when you are."

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    GhostArtwork()
                    Text("Capture the conversation before it fades.")
                        .font(.title3.weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(GhostTheme.ghostWhite)

                    Text(statusMessage)
                        .font(.subheadline)
                        .foregroundStyle(GhostTheme.mist)
                        .multilineTextAlignment(.center)

                    Text(formattedDuration)
                        .font(.system(size: 48, weight: .light, design: .monospaced))
                        .foregroundStyle(recordingService.isRecording ? GhostTheme.pumpkin : GhostTheme.ghostWhite)
                        .contentTransition(.numericText())

                    Button {
                        toggleRecording()
                    } label: {
                        Label(recordingService.isRecording ? "Stop recording" : "Start recording", systemImage: recordingService.isRecording ? "stop.fill" : "mic.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(recordingService.isRecording ? GhostTheme.pumpkin : GhostTheme.lavender)
                            .foregroundStyle(GhostTheme.background)
                            .clipShape(Capsule())
                    }
                    .accessibilityIdentifier("recordButton")

                    if phase == .recorded || phase == .transcribed || phase == .generated {
                        transcriptSection
                    }

                    if phase == .generated {
                        Label("Minutes saved. Open the Minutes tab to review them.", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(GhostTheme.lavender)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(24)
            }
            .navigationTitle("GhostNotes")
            .ghostBackground()
        }
    }

    private var transcriptSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if phase == .recorded {
                Button {
                    transcribeSample()
                } label: {
                    Label("Transcribe sample meeting", systemImage: "text.word.spacing")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(GhostTheme.lavender)
            }

            if !transcript.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Transcript")
                        .font(.headline)
                        .foregroundStyle(GhostTheme.ghostWhite)
                    Text(transcript)
                        .font(.body)
                        .foregroundStyle(GhostTheme.mist)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(GhostTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if phase == .transcribed {
                    Button {
                        generateMinutes()
                    } label: {
                        Label("Generate minutes", systemImage: "sparkles")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(GhostTheme.pumpkin)
                }
            }
        }
    }

    private var formattedDuration: String {
        let totalSeconds = Int(recordingService.elapsedTime)
        return String(format: "%02d:%02d", totalSeconds / 60, totalSeconds % 60)
    }

    private func toggleRecording() {
        if recordingService.isRecording {
            recordingService.stop()
            phase = .recorded
            statusMessage = "Recording captured. Turn it into text next."
        } else {
            recordingService.start()
            phase = .recording
            transcript = ""
            statusMessage = "Listening for the important parts..."
        }
    }

    private func transcribeSample() {
        Task {
            do {
                transcript = try await MockTranscriptionService().transcribe(audioFileReference: nil)
                phase = .transcribed
                statusMessage = "Transcript ready."
            } catch {
                statusMessage = error.localizedDescription
            }
        }
    }

    private func generateMinutes() {
        Task {
            do {
                let draft = try await StubMinutesGenerator().generateMinutes(from: transcript)
                let actionItems = draft.actionItems.map {
                    ActionItem(title: $0.title, owner: $0.owner, dueDate: $0.dueDate)
                }
                let minutes = Minutes(
                    summary: draft.summary,
                    decisions: draft.decisions,
                    actionItems: actionItems
                )
                let meeting = Meeting(
                    title: "Recorded meeting",
                    audioFileReference: "mock://latest-recording",
                    transcriptText: transcript,
                    minutes: minutes
                )
                minutes.meeting = meeting
                actionItems.forEach { $0.minutes = minutes }
                modelContext.insert(meeting)
                modelContext.insert(minutes)
                actionItems.forEach { modelContext.insert($0) }
                try modelContext.save()
                phase = .generated
                statusMessage = "Structured minutes are ready."
            } catch {
                statusMessage = error.localizedDescription
            }
        }
    }
}

private struct GhostArtwork: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(GhostTheme.lavender.opacity(0.16))
                .frame(width: 150, height: 150)
            Image(systemName: "figure.wave")
                .font(.system(size: 72, weight: .ultraLight))
                .foregroundStyle(GhostTheme.ghostWhite)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    RecordingView()
        .modelContainer(for: [Meeting.self, Minutes.self, ActionItem.self], inMemory: true)
}
