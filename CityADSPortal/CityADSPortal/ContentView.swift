
import SwiftUI

struct ContentView: View {
    
    @State var loginSucsses = false
    @StateObject var authManager = AuthenticationManager()
    
    var body: some View {
        ZStack{
            if authManager.isAuthenticated {
                MainScreen(idUser: authManager.idUser)
            } else {
                LoginScreen()
                    .environmentObject(authManager)
            }
        }.alert(isPresented: $authManager.showAlertBio) {
            Alert(title: Text("Do you want save password and use Biometric?"),
                  primaryButton: .default(Text("Yes") )
                  { do { try authManager.saveInKeyChain() } catch {} },
                  secondaryButton: .cancel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
