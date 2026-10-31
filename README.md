# GhostNotes

GhostNotes is an iOS app for meetings where spoken words should not disappear. It records a meeting, transcribes it on-device, turns the transcript into structured minutes, and exports the result as Markdown. This repository contains the first runnable scaffold, so its recording, transcription, and minutes generation paths use deterministic mock data.

## Core flows

1. **Record:** Start and stop a meeting recording with a live timer UI.
2. **Transcribe on-device:** Continue to a transcript screen using the Apple Speech service boundary. The scaffold displays sample transcript text without requesting permission or making a network call.
3. **Generate minutes:** Convert the transcript into a summary, decisions, and action items with owners and optional due dates through `MinutesGenerating`.
4. **Export:** Preview the generated Markdown and open the iOS share sheet. EventKit Reminders integration is reserved for a follow-up implementation.

## Build and run

Requirements:

- macOS with Xcode 27.2 or later and an iOS 17+ simulator runtime.
- The repository's app target is `GhostNotes` and its test target is `GhostNotesTests`.

Build the app from the repository root:

```sh
xcodebuild build \
  -project GhostNotes.xcodeproj \
  -scheme GhostNotes \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

Run the unit tests:

```sh
xcodebuild test \
  -project GhostNotes.xcodeproj \
  -scheme GhostNotes \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

Open `GhostNotes.xcodeproj` in Xcode to run the app in a simulator. The scaffold does not need an API key. `Config.example.xcconfig` documents the local placeholder for future Gemini work; copy it to the ignored `Config.secrets.xcconfig` only when developing a real integration.

## Built with Kiro

The implementation started with the structured spec in `.kiro/specs/ghostnotes-scaffold/`, including requirements, design, and an implementation checklist. `.kiro/steering/` records the product, Swift/SwiftUI, SwiftData, and folder conventions. `.kiro/hooks/format-and-test-on-save.json` defines a documented `PostFileSave` hook that formats Swift files and runs the unit tests after Kiro saves a Swift source file. Kiro metadata is intentionally committed as part of the project evidence.

## License

GhostNotes is released under the [MIT License](LICENSE). Copyright (c) 2026 Xiaodong Jiang.
