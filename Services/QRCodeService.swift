import Foundation
import UIKit
import CoreImage

class QRCodeService {
    
    func generateARQRCode(for model: ScanModel) -> UIImage? {
        // Créer une URL ou un identifiant unique pour le modèle AR
        let arURL = "ar3dscan://model/\(model.id.uuidString)"
        
        // Générer le QR code
        guard let filter = CIFilter(name: "CIQRCodeGenerator"),
              let data = arURL.data(using: .utf8) else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        // Convertir en UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        let qrImage = UIImage(cgImage: cgImage)
        
        // Redimensionner pour une meilleure qualité
        let scale = 10.0
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledImage = outputImage.transformed(by: transform)
        
        guard let scaledCGImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return qrImage
        }
        
        return UIImage(cgImage: scaledCGImage)
    }
    
    func generateWebQRCode(webURL: String) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator"),
              let data = webURL.data(using: .utf8) else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        let scale = 10.0
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledImage = outputImage.transformed(by: transform)
        
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

