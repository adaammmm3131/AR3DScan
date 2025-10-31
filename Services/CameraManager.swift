import Foundation
import AVFoundation
import UIKit

class CameraManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private var videoOutput: AVCaptureMovieFileOutput?
    private var currentVideoURL: URL?
    
    func setupCamera() {
        session.sessionPreset = .high
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        videoOutput = AVCaptureMovieFileOutput()
        if let output = videoOutput, session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func startRecording() {
        guard let output = videoOutput else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let videoURL = documentsPath.appendingPathComponent("scan_\(UUID().uuidString).mov")
        currentVideoURL = videoURL
        
        output.startRecording(to: videoURL, recordingDelegate: self)
    }
    
    func stopRecording(completion: @escaping (URL?) -> Void) {
        videoOutput?.stopRecording()
        completion(currentVideoURL)
    }
    
    func switchCamera() {
        session.beginConfiguration()
        
        if let input = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(input)
            
            let newPosition: AVCaptureDevice.Position = input.device.position == .back ? .front : .back
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: device) else {
                session.commitConfiguration()
                return
            }
            
            if session.canAddInput(newInput) {
                session.addInput(newInput)
            }
        }
        
        session.commitConfiguration()
    }
    
    func stopSession() {
        session.stopRunning()
    }
}

extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Erreur d'enregistrement: \(error.localizedDescription)")
        }
    }
}

