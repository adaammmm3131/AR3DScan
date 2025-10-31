import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScanViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Onglet Scan
            ScanView(viewModel: viewModel)
                .tabItem {
                    Label("Scanner", systemImage: "camera.viewfinder")
                }
                .tag(0)
            
            // Onglet Bibliothèque
            LibraryView(viewModel: viewModel)
                .tabItem {
                    Label("Bibliothèque", systemImage: "square.grid.2x2")
                }
                .tag(1)
            
            // Onglet Paramètres
            SettingsView()
                .tabItem {
                    Label("Paramètres", systemImage: "gearshape")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}

