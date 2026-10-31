import AVFoundation
import Combine
import Foundation

@MainActor
protocol AudioRecordingService: AnyObject {
    var isRecording: Bool { get }
    var elapsedTime: TimeInterval { get }
    func start()
    func stop()
}

/// AVFoundation-backed recording boundary. The scaffold uses the mock below so it needs no permission prompt.
final class AVFoundationAudioRecordingService: AudioRecordingService {
    private(set) var isRecording = false
    private(set) var elapsedTime: TimeInterval = 0
    private var recorder: AVAudioRecorder?

    func start() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("ghostnotes-recording.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        recorder = try? AVAudioRecorder(url: fileURL, settings: settings)
        recorder?.record()
        isRecording = recorder?.isRecording == true
        elapsedTime = 0
    }

    func stop() {
        elapsedTime = recorder?.currentTime ?? elapsedTime
        recorder?.stop()
        recorder = nil
        isRecording = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

@MainActor
final class MockAudioRecordingService: NSObject, ObservableObject, AudioRecordingService {
    @Published private(set) var isRecording = false
    @Published private(set) var elapsedTime: TimeInterval = 0

    private var startedAt: Date?
    private var timer: Timer?

    func start() {
        guard !isRecording else { return }
        isRecording = true
        elapsedTime = 0
        startedAt = .now
        timer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(updateElapsedTime),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func updateElapsedTime() {
        guard let startedAt else { return }
        elapsedTime = Date.now.timeIntervalSince(startedAt)
    }

    func stop() {
        guard isRecording else { return }
        isRecording = false
        if let startedAt {
            elapsedTime = Date.now.timeIntervalSince(startedAt)
        }
        timer?.invalidate()
        timer = nil
    }

    deinit {
        timer?.invalidate()
    }
}
