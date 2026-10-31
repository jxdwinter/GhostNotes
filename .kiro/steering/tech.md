---
inclusion: always
---

# GhostNotes Technical Conventions

- Use Swift and SwiftUI for an iOS 17+ deployment target.
- Use SwiftData `@Model` types for persisted domain data.
- Use AVFoundation for recording boundaries and Apple Speech for the future on-device transcription implementation.
- Keep platform and external integrations behind protocols with deterministic mocks for previews and tests.
- Use EventKit only in the future Reminders integration; the scaffold's export behavior uses Markdown and the system share sheet.
- Never hardcode secrets. Read future API configuration from untracked local config or environment values, and keep only placeholders in the repository.
- Prefer small, focused views and service types. Keep formatting logic in services so it can be tested without a view.
- Use Swift Testing for unit tests where the SDK supports it.
