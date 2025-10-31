import SwiftUI
import ARKit
import RealityKit

struct ModelDetailView: View {
    let model: ScanModel
    @ObservedObject var viewModel: ScanViewModel
    @State private var showARView = false
    @State private var showQRCode = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Miniature AR
                    ARPreviewView(modelURL: model.modelURL)
                        .frame(height: 300)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                    
                    // Informations
                    VStack(alignment: .leading, spacing: 15) {
                        InfoRow(label: "Nom", value: model.name)
                        InfoRow(label: "Date de création", value: model.createdAt.formatted(date: .long, time: .shortened))
                        InfoRow(label: "Format", value: "USDZ")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // Actions
                    VStack(spacing: 15) {
                        Button(action: {
                            showARView = true
                        }) {
                            HStack {
                                Image(systemName: "arkit")
                                Text("Voir en réalité augmentée")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            showQRCode = true
                        }) {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("Générer QR Code AR")
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                        }
                        
                        Button(action: {
                            viewModel.shareModel(model)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Partager")
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(model.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showARView) {
                ARViewWrapper(modelURL: model.modelURL)
            }
            .sheet(isPresented: $showQRCode) {
                QRCodeView(model: model)
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct ARPreviewView: View {
    let modelURL: URL
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
            
            // Placeholder pour la prévisualisation AR
            VStack {
                Image(systemName: "cube.box.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Aperçu 3D")
                    .font(.headline)
                    .padding(.top)
            }
        }
    }
}

