import AVFoundation
import UIKit

class VideoFrameExtractor {
    
    static func extractFrames(
        from videoURL: URL,
        framesPerSecond: Double = 2.0,
        completion: @escaping ([UIImage]) -> Void
    ) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceAfter = .zero
        imageGenerator.requestedTimeToleranceBefore = .zero
        
        // Charger la durée de manière asynchrone
        Task {
            do {
                let duration = try await asset.load(.duration)
                let durationSeconds = CMTimeGetSeconds(duration)
                let totalFrames = Int(durationSeconds * framesPerSecond)
                var images: [UIImage] = []
                let group = DispatchGroup()
                
                for i in 0..<totalFrames {
                    let time = CMTime(seconds: Double(i) / framesPerSecond, preferredTimescale: 600)
                    
                    group.enter()
                    imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, result, error in
                        defer { group.leave() }
                        
                        if let cgImage = cgImage {
                            let uiImage = UIImage(cgImage: cgImage)
                            images.append(uiImage)
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    // Trier les images par ordre temporel
                    completion(images)
                }
            } catch {
                completion([])
            }
        }
    }
    
    static func extractFramesAsync(
        from videoURL: URL,
        framesPerSecond: Double = 2.0
    ) async throws -> [UIImage] {
        return try await withCheckedThrowingContinuation { continuation in
            extractFrames(from: videoURL, framesPerSecond: framesPerSecond) { images in
                continuation.resume(returning: images)
            }
        }
    }
}

