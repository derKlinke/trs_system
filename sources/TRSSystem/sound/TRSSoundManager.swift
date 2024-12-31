import AppKit

@MainActor
public class TRSSoundManager {
    public static let shared = TRSSoundManager()

    public enum TRSSound: String, CaseIterable, Sendable {
        case copy
        case add
        case error
    }

    struct Sound {
        let name: TRSSound
        let sound: NSSound
    }

    private var sounds: [Sound] = []

    let queue = DispatchQueue(label: "TRS Sound Queue", qos: .userInitiated, attributes: .concurrent)

    private init() {
        for sound in TRSSound.allCases {
            // get url in bundle
            if let url = Bundle.module.url(forResource: sound.rawValue, withExtension: "wav") {
                // create sound
                if let nsSound = NSSound(contentsOf: url, byReference: false) {
                    sounds.append(Sound(name: sound, sound: nsSound))
                } else {
                    fatalError("Could not create sound for: \(sound.rawValue)")
                }
            } else {
                fatalError("Could not find sound file: \(sound.rawValue)")
            }
        }
    }

    public func play(sound: TRSSound) {

            self.sounds.first { $0.name == sound }?.sound.play()

            // TODO: test if this works and how it feels
            NSHapticFeedbackManager.defaultPerformer
                .perform(NSHapticFeedbackManager.FeedbackPattern.alignment,
                         performanceTime: .default)

            // TODO: add automatic variations by pitch shifting

    }
}
