
import SwiftUI

struct LoginScreen: View {
    
    private let bio = Biometric()
    @State var login: String = ""
    @State var password: String = ""
    @State var isErrorAnimation: Bool = false
    @State var pressLogin = false
    @Binding var isLogin: Bool
    
    
    var body: some View {
        VStack{
            Spacer()
            Image("CAlogo")
                .shadow(radius: 3)
            Spacer()
            TextField("Login", text: $login)
                .modifier(LoginText(isError: $isErrorAnimation, pressLogin: $pressLogin))
            SecureField("password", text: $password)
                .modifier(LoginText(isError: $isErrorAnimation, pressLogin: $pressLogin))
                .offset(CGSize(width: isErrorAnimation ? 5 : 0, height: 0))
            LoginButton(login: $login,
                        password: $password,
                        isError: $isErrorAnimation,
                        loginSucsses: $isLogin,
                        pressLogin: $pressLogin)
                .padding(30)
            Spacer()
            
        }.onAppear(){
            bio.authenticate(){ success in
                isLogin = success
            }
        }
    }
}

struct LoginButton: View {
    
    @Binding var login: String
    @Binding var password: String
    @Binding var isError: Bool
    @Binding var loginSucsses: Bool
    @Binding var pressLogin: Bool
    
    let network = NetworkService.shared
    
    var body: some View {
        
        Button("Login") {
            pressLogin = true
            signIn()
        }
        .buttonStyle(.borderless)
    }
    
    func signIn() {
        network.login(login: login, password: password) {result in
            switch result.success {
            case true :
                loginSucsses = true
            case false:
                let animation = Animation.easeInOut(duration: 0.1).repeatCount(5)
                pressLogin = false
                withAnimation(animation) {
                    isError = !result.success
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut) {
                        isError = false
                    }
                }
            }
        }
    }
}

struct LoginText: ViewModifier {
    @Binding var isError: Bool
    @Binding var pressLogin: Bool
    static let screenWidth = UIScreen.main.bounds.size.width
    static let textfildsWidth = screenWidth/1.6  >= 220 ? screenWidth/1.6 : 220
    
    func body(content: Content) -> some View {
        let colorBorder = isError ? Color(.red) : Color("DigitalCYAN")
        content
            .frame(width: LoginText.textfildsWidth, height: 30)
            .padding(.leading, 10)
            .disabled(pressLogin)
            .disableAutocorrection(true)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(colorBorder, lineWidth: 2)
            )
    }
}






//_____________________________________________________________
//struct LoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginScreen(isLogin: false)
//    }
//}
