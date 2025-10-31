import SwiftUI
import AVFoundation
import Photos

struct CameraCaptureView: View {
    @ObservedObject var viewModel: ScanViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var isRecording = false
    @State private var recordingTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            CameraPreview(session: cameraManager.session)
                .ignoresSafeArea()
            
            VStack {
                // Indicateur d'enregistrement
                if isRecording {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                        Text("Enregistrement")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(formatTime(recordingTime))
                            .font(.monospaced(.body)())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(20)
                    .padding(.top, 50)
                }
                
                Spacer()
                
                // Instructions
                if !isRecording {
                    VStack(spacing: 10) {
                        Text("Déplacez-vous autour de l'objet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(15)
                        
                        Text("Capturez l'objet sous tous les angles à 360°")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                    }
                }
                
                // Contrôles
                HStack(spacing: 40) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(isRecording ? Color.red : Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .frame(width: 75, height: 75)
                                )
                        }
                    }
                    
                    Button(action: {
                        cameraManager.switchCamera()
                    }) {
                        Image(systemName: "camera.rotate")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            cameraManager.setupCamera()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
    }
    
    private func startRecording() {
        isRecording = true
        cameraManager.startRecording()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingTime += 0.1
        }
    }
    
    private func stopRecording() {
        isRecording = false
        timer?.invalidate()
        timer = nil
        
        cameraManager.stopRecording { videoURL in
            if let url = videoURL {
                viewModel.processVideo(url) { result in
                    switch result {
                    case .success:
                        dismiss()
                    case .failure(let error):
                        print("Erreur: \(error)")
                    }
                }
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}

