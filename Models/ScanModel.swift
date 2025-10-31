import Foundation

struct ScanModel: Identifiable, Codable {
    let id: UUID
    var name: String
    let createdAt: Date
    let modelURL: URL
    let thumbnailURL: URL?
    var qrCodeData: Data?
    
    init(name: String, modelURL: URL) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.modelURL = modelURL
        self.thumbnailURL = nil
        self.qrCodeData = nil
    }
}

