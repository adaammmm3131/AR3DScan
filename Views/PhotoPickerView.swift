import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedImages: [UIImage]
    @ObservedObject var viewModel: ScanViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 50,
                    matching: .images
                ) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Sélectionner des photos")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding()
                }
                
                if !selectedImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    
                    Button(action: {
                        processImages()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Traiter les images")
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
                        .padding()
                    }
                    .disabled(viewModel.isProcessing)
                }
                
                Spacer()
            }
            .navigationTitle("Sélectionner des photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedItems) { items in
                loadImages(from: items)
            }
            .overlay {
                if viewModel.isProcessing {
                    ProcessingOverlay(progress: viewModel.processingProgress)
                }
            }
        }
    }
    
    private func loadImages(from items: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []
            
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }
            
            await MainActor.run {
                selectedImages = images
            }
        }
    }
    
    private func processImages() {
        viewModel.processImages(selectedImages) { result in
            switch result {
            case .success:
                dismiss()
            case .failure(let error):
                print("Erreur: \(error.localizedDescription)")
            }
        }
    }
}

struct ProcessingOverlay: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView(value: progress, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .frame(width: 200)
                
                Text("Traitement en cours...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(Int(progress))%")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
        }
    }
}

