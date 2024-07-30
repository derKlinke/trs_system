import AppKit

public class TRSSoundManager {
    public static let shared = TRSSoundManager()

    public enum TRSSound: String, CaseIterable {
        case copy
        case add
        case error
    }

    private var sounds = [TRSSound: NSSound]()

    let queue = DispatchQueue(label: "TRS Sound Queue", qos: .userInitiated, attributes: .concurrent)

    private init() {
        for sound in TRSSound.allCases {
            // get url in bundle
            if let url = Bundle.module.url(forResource: sound.rawValue, withExtension: "wav") {
                // create sound
                if let nsSound = NSSound(contentsOf: url, byReference: false) {
                    sounds[sound] = nsSound
                } else {
                    fatalError("Could not create sound for: \(sound.rawValue)")
                }
            } else {
                fatalError("Could not find sound file: \(sound.rawValue)")
            }
        }
    }

    public func play(sound: TRSSound) {
        queue.async {
            self.sounds[sound]!.play()
            
            // TODO: test if this works and how it feels
            NSHapticFeedbackManager.defaultPerformer
                .perform(NSHapticFeedbackManager.FeedbackPattern.alignment,
                         performanceTime: .default)
            
            // TODO: add automatic variations by pitch shifting
        }
    }
}
