import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showAddAccountSheet: Bool = false
    
    
    var body : some View {
        List {
            
            if authViewModel.session == nil {
                Section("Accounts") {
                    Button("Add account", systemImage: "person.badge.plus") {
                        showAddAccountSheet.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddAccountSheet) {
            WelcomeScreen()
        }
    }
}


#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
