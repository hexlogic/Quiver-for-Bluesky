import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text("Quiver")
                    .bold()
                Text("for Bluesky")
                Spacer()
                Button("Create an account") {
                    
                }
                .buttonStyle(.borderedProminent)
                .padding()
                NavigationLink("Login") {
                    LoginView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeScreen()
    }
}
