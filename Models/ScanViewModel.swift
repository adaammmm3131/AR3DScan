import Foundation
import SwiftUI
import PhotosUI
import AVFoundation
import UIKit

@MainActor
class ScanViewModel: ObservableObject {
    @Published var scanModels: [ScanModel] = []
    @Published var isProcessing = false
    @Published var processingProgress: Double = 0.0
    @Published var errorMessage: String?
    
    private let photogrammetryService = PhotogrammetryService()
    
    init() {
        loadModels()
    }
    
    func requestPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            // Gérer l'autorisation caméra
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            // Gérer l'autorisation photo
        }
    }
    
    func processImages(_ images: [UIImage], completion: @escaping (Result<URL, Error>) -> Void) {
        isProcessing = true
        processingProgress = 0.0
        
        Task {
            do {
                // Préparer les images
                let imageURLs = try await prepareImages(images)
                
                // Traitement photogrammétrie
                processingProgress = 30.0
                let modelURL = try await photogrammetryService.createModel(from: imageURLs) { progress in
                    Task { @MainActor in
                        self.processingProgress = 30.0 + (progress * 0.7)
                    }
                }
                
                processingProgress = 100.0
                
                // Créer le modèle
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                let scanModel = ScanModel(
                    name: "Scan \(dateFormatter.string(from: Date()))",
                    modelURL: modelURL
                )
                
                scanModels.append(scanModel)
                saveModels()
                
                isProcessing = false
                completion(.success(modelURL))
                
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                completion(.failure(error))
            }
        }
    }
    
    func processVideo(_ videoURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        isProcessing = true
        processingProgress = 0.0
        
        Task {
            do {
                // Extraire les frames de la vidéo
                processingProgress = 10.0
                let images = try await extractFrames(from: videoURL)
                
                // Traiter comme des images
                processImages(images) { result in
                    completion(result)
                }
                
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                completion(.failure(error))
            }
        }
    }
    
    private func prepareImages(_ images: [UIImage]) async throws -> [URL] {
        let tempDir = FileManager.default.temporaryDirectory
        var urls: [URL] = []
        
        for (index, image) in images.enumerated() {
            let url = tempDir.appendingPathComponent("image_\(index).jpg")
            if let jpegData = image.jpegData(compressionQuality: 0.9) {
                try jpegData.write(to: url)
                urls.append(url)
            }
        }
        
        return urls
    }
    
    private func extractFrames(from videoURL: URL) async throws -> [UIImage] {
        return try await VideoFrameExtractor.extractFramesAsync(
            from: videoURL,
            framesPerSecond: 2.0
        )
    }
    
    func generateQRCode(for model: ScanModel) -> UIImage? {
        let qrService = QRCodeService()
        return qrService.generateARQRCode(for: model)
    }
    
    func shareModel(_ model: ScanModel) {
        // Implémentation du partage
    }
    
    private func saveModels() {
        // Sauvegarder les modèles dans UserDefaults ou Core Data
        if let encoded = try? JSONEncoder().encode(scanModels) {
            UserDefaults.standard.set(encoded, forKey: "scanModels")
        }
    }
    
    private func loadModels() {
        if let data = UserDefaults.standard.data(forKey: "scanModels"),
           let models = try? JSONDecoder().decode([ScanModel].self, from: data) {
            scanModels = models
        }
    }
}

