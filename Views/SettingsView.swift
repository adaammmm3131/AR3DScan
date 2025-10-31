import SwiftUI

struct SettingsView: View {
    @AppStorage("highQuality") private var highQuality = true
    @AppStorage("autoGenerateQR") private var autoGenerateQR = false
    @AppStorage("saveToLibrary") private var saveToLibrary = true
    
    var body: some View {
        NavigationView {
            Form {
                Section("Qualité de capture") {
                    Toggle("Haute qualité", isOn: $highQuality)
                    
                    Picker("Résolution", selection: .constant(0)) {
                        Text("Standard").tag(0)
                        Text("Haute").tag(1)
                        Text("Ultra").tag(2)
                    }
                }
                
                Section("Options") {
                    Toggle("Générer QR Code automatiquement", isOn: $autoGenerateQR)
                    Toggle("Sauvegarder dans la photothèque", isOn: $saveToLibrary)
                }
                
                Section("À propos") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Aide et support", destination: URL(string: "https://ar-code.com")!)
                    Link("Politique de confidentialité", destination: URL(string: "https://ar-code.com/privacy")!)
                }
            }
            .navigationTitle("Paramètres")
        }
    }
}

