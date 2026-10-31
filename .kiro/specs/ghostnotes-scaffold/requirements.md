# GhostNotes Scaffold Requirements

## Goal

Build an iOS 17+ SwiftUI scaffold that demonstrates the complete GhostNotes flow with deterministic mock services and no API key.

## Requirements

### R1. Record a meeting

- The app shall present a Recording screen with a GhostNotes-themed background and a record control.
- Tapping the record control shall start and stop a live elapsed-time display without requiring microphone access in the scaffold.
- The screen shall provide a path to continue the mock pipeline after recording.
- The recording service shall be represented by a protocol and a working mock implementation.

### R2. Transcribe on-device boundary

- The app shall represent transcription behind a service protocol whose production boundary uses Apple Speech APIs and whose scaffold implementation returns sample transcript text.
- Continuing from Recording shall present sample transcript text and a control to generate minutes.
- No API key or network call shall be required to reach the transcript state.

### R3. Generate structured minutes

- Minutes generation shall be represented by a `MinutesGenerating` protocol.
- The scaffold shall provide a stub generator that returns a summary, decisions, and action items with owners and optional due dates.
- The minutes list and detail screens shall be reachable with mock data.
- The detail screen shall display summary, decisions, and action items using the ghost/Halloween theme.

### R4. Export minutes

- The export service shall convert a minutes object into Markdown containing the summary, decisions, and action items.
- The detail screen shall show a Markdown preview and provide a share-sheet entry point.
- Export shall work with mock data and without a network connection.

### R5. Persistence and models

- `Meeting`, `Minutes`, and `ActionItem` shall be SwiftData models with the required fields.
- The app shall configure a SwiftData model container and launch without requiring pre-existing data.
- The scaffold shall preserve clear relationships between a meeting, its minutes, and its action items.

### R6. Quality and repository evidence

- The repository shall include unit smoke tests covering model creation, minutes formatting, and Markdown export output.
- The Xcode project shall build with `xcodebuild` for an iOS 17+ simulator destination.
- The repository shall include the required root README, MIT license, `.kiro` spec and steering files, hook configuration, and secret-safe example configuration.
