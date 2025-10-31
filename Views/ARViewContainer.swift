import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    let modelURL: URL
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configuration de la session AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Charger et afficher le modèle 3D
        loadModel(in: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func loadModel(in arView: ARView) {
        // Charger le modèle USDZ
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        do {
            let modelEntity = try Entity.load(contentsOf: modelURL)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
        } catch {
            print("Erreur de chargement du modèle: \(error)")
            
            // Afficher un cube de substitution
            let box = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .blue, isMetallic: false)]
            )
            anchorEntity.addChild(box)
            arView.scene.addAnchor(anchorEntity)
        }
    }
}

struct ARViewWrapper: View {
    let modelURL: URL
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ARViewContainer(modelURL: modelURL)
                .ignoresSafeArea()
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}

