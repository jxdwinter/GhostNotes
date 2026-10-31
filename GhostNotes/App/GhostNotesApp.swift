import SwiftData
import SwiftUI

@main
struct GhostNotesApp: App {
    private let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            Meeting.self,
            Minutes.self,
            ActionItem.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Unable to create the GhostNotes model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
