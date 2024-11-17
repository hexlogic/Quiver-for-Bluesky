import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @State var username: String = ""
    @State var password: String = ""
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            
            Form {
                TextField(
                    "Username or email address",
                    text: $username
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .invalidatableContent(username.isEmpty)
                SecureField(
                    "Password",
                    text: $password
                )
                HStack {
                    Button(action: login) {
                        Text("Login")
                    }
                    Spacer()
                    Button(action: login) {
                        Text("Forgot password?")
                    }
                }
            }
            .frame(maxHeight: 200)
            if authViewModel.isLoading {
                ProgressView()
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            if authViewModel.errorMessage != nil && !authViewModel.isLoading {
                Text(authViewModel.errorMessage!)
                    .foregroundStyle(.red)
            }
            
        }
    }
    
    private func login() {
        Task {
            await authViewModel.createSession(identifier: username, password: password)
        }
    }
}
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
