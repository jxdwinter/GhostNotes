# GhostNotes Scaffold Design

## Architecture

GhostNotes uses SwiftUI with a small MVVM-style presentation layer. Views own only screen state and delegate work to protocols. SwiftData models represent persisted domain data. Services isolate platform APIs and external generation so the scaffold can run with deterministic mocks.

## Pipeline

1. `RecordingView` starts and stops `AudioRecordingService` and displays elapsed time.
2. A recording continuation asks `TranscriptionService` for transcript text. The scaffold uses `MockTranscriptionService`; a future implementation can use `SFSpeechRecognizer` with on-device recognition.
3. `MinutesGenerating` turns the transcript into a `Minutes` value. `StubMinutesGenerator` returns deterministic summary, decisions, and action items. `GeminiMinutesGenerator` is a skeleton that reads an injected API key/configuration and intentionally does not make a real request in this scaffold.
4. `ExportService` formats `Minutes` as Markdown. `MinutesDetailView` previews the Markdown and uses `ShareLink` for the system share sheet.

## Layers and responsibilities

- `App/`: app entry point, model container, and root navigation.
- `Features/Recording/`: recording and mock pipeline transition UI.
- `Features/Minutes/`: minutes list and detail/export UI.
- `Core/Models/`: SwiftData models and domain value types.
- `Core/Services/`: protocol boundaries and platform/mock implementations.
- `Core/Theme/`: centralized ghost/Halloween colors and reusable view styling.

## Persistence

`@Model` types are `Meeting`, `Minutes`, and `ActionItem`. `Minutes` owns to-many action items and stores decisions as a string array. The app creates a `ModelContainer` for the three model types and seeds one sample meeting/minutes record when the store is empty. The app can therefore launch directly into useful mock data.

## Navigation

`ContentView` provides a `TabView` with Recording and Minutes tabs. `MinutesListView` pushes `MinutesDetailView` through `NavigationStack`. Recording transitions to the mock transcript/minutes flow with in-memory state and then inserts the generated minutes into SwiftData.

## Service protocols

- `AudioRecordingService`: start/stop recording, recording state, and elapsed duration.
- `TranscriptionService`: transcribe an audio file reference or return sample transcript text.
- `MinutesGenerating`: generate structured minutes from transcript text.
- `Exporting`: render minutes as Markdown.

Each protocol has a usable scaffold implementation. Platform implementation seams are documented without requiring permissions, API keys, or network calls.

## Testing

`GhostNotesTests/SmokeTests.swift` uses the Swift Testing framework available with the iOS 17 SDK. Tests construct models in memory, verify minutes formatting, and assert required sections/content in Markdown output. Service tests stay deterministic by using the stub implementations.
