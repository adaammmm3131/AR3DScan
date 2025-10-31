import SwiftUI

struct QRCodeView: View {
    let model: ScanModel
    private let qrService = QRCodeService()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                if let qrImage = qrService.generateARQRCode(for: model) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding()
                } else {
                    Text("Erreur de génération du QR Code")
                        .foregroundColor(.red)
                }
                
                VStack(spacing: 15) {
                    Text("Scannez ce code pour voir le modèle en AR")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("Compatible avec tous les appareils iOS et Android")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                Button(action: {
                    // Sauvegarder ou partager le QR code
                    if let qrImage = qrService.generateARQRCode(for: model) {
                        UIImageWriteToSavedPhotosAlbum(qrImage, nil, nil, nil)
                    }
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Sauvegarder")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("QR Code AR")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

