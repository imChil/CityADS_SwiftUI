
import SwiftUI

struct ContentView: View {
    
    @State var loginSucsses = false
    
    var body: some View {
        NavigationViewController(
            transition: .none
        ) {
                if loginSucsses {
                    MainScreen()
                } else {
                    LoginScreen(isLogin: $loginSucsses)
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
