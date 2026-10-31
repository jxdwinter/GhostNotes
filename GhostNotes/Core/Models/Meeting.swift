import Foundation
import SwiftData

@Model
final class Meeting {
    var id: UUID
    var title: String
    var date: Date
    var audioFileReference: String?
    var transcriptText: String
    @Relationship(deleteRule: .cascade, inverse: \Minutes.meeting)
    var minutes: Minutes?

    init(
        id: UUID = UUID(),
        title: String,
        date: Date = .now,
        audioFileReference: String? = nil,
        transcriptText: String = "",
        minutes: Minutes? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.audioFileReference = audioFileReference
        self.transcriptText = transcriptText
        self.minutes = minutes
    }
}
