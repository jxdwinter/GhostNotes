---
inclusion: always
---

# GhostNotes Structure

- `GhostNotes/App/` contains app entry and root content navigation.
- `GhostNotes/Features/<Feature>/` contains feature views grouped by feature.
- `GhostNotes/Core/Models/` contains SwiftData models.
- `GhostNotes/Core/Services/` contains service protocols and implementations.
- `GhostNotes/Core/Theme/` contains shared visual tokens and modifiers.
- `GhostNotesTests/` contains unit and smoke tests.

Use one primary type per file, matching the filename. Name protocols with a capability-oriented noun or an `-ing` suffix, implementations with descriptive concrete names, and views with the `View` suffix. Keep domain names stable across persistence, services, and views.
