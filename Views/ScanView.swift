import SwiftUI
import AVFoundation
import PhotosUI

struct ScanView: View {
    @ObservedObject var viewModel: ScanViewModel
    @State private var isCapturing = false
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var showGuide = false
    @State private var captureProgress: Double = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // En-tête
                    VStack(spacing: 10) {
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Scan 3D")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Capturez votre objet sous tous les angles")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Guide de capture
                    if showGuide {
                        CaptureGuideView()
                            .transition(.move(edge: .bottom))
                    }
                    
                    // Zone de progression
                    if isCapturing {
                        VStack(spacing: 15) {
                            ProgressView(value: captureProgress, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                            Text("\(Int(captureProgress))%")
                                .font(.headline)
                            
                            Text("Traitement en cours...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                    
                    Spacer()
                    
                    // Boutons d'action
                    VStack(spacing: 15) {
                        // Bouton Capture Vidéo
                        Button(action: {
                            showCamera = true
                        }) {
                            HStack {
                                Image(systemName: "video.fill")
                                Text("Capturer une vidéo")
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
                            .shadow(radius: 5)
                        }
                        
                        // Bouton Importer Photos
                        Button(action: {
                            showPhotoPicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Importer des photos")
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
                            .shadow(radius: 5)
                        }
                        
                        // Bouton Aide
                        Button(action: {
                            withAnimation {
                                showGuide.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: showGuide ? "xmark.circle" : "questionmark.circle")
                                Text(showGuide ? "Masquer l'aide" : "Afficher l'aide")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Nouveau Scan")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCamera) {
                CameraCaptureView(viewModel: viewModel)
            }
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPickerView(selectedImages: $selectedImages, viewModel: viewModel)
            }
            .onAppear {
                viewModel.requestPermissions()
            }
        }
    }
}

struct CaptureGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Conseils pour une capture optimale")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                GuideItem(icon: "1.circle.fill", text: "Déplacez-vous autour de l'objet à 360°")
                GuideItem(icon: "2.circle.fill", text: "Utilisez un éclairage uniforme")
                GuideItem(icon: "3.circle.fill", text: "Prenez au moins 20-30 photos")
                GuideItem(icon: "4.circle.fill", text: "Évitez les surfaces réfléchissantes")
            }
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

struct GuideItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

