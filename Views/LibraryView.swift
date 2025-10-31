import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: ScanViewModel
    @State private var selectedModel: ScanModel?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(viewModel.scanModels) { model in
                        ModelCard(model: model)
                            .onTapGesture {
                                selectedModel = model
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Mes Scans")
            .sheet(item: $selectedModel) { model in
                ModelDetailView(model: model, viewModel: viewModel)
            }
            .overlay {
                if viewModel.scanModels.isEmpty {
                    EmptyStateView()
                }
            }
        }
    }
}

struct ModelCard: View {
    let model: ScanModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Miniature 3D
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 150)
                
                Image(systemName: "cube.box.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(model.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(model.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cube.box")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Aucun scan pour le moment")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Commencez par créer votre premier scan 3D")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

