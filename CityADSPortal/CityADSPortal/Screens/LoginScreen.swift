
import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var authManager : AuthenticationManager
    @State var isErrorAnimation: Bool = false
    @State var pressLogin = false
    @State var isShowMessageError = false
    
    var body: some View {
        VStack{
            Spacer()
            Image("CAlogo")
                .shadow(radius: 3)
            Spacer()
            TextField("Login", text: $authManager.credentials.username)
                .modifier(LoginText(isError: $isErrorAnimation, pressLogin: $pressLogin))
            SecureField("password", text: $authManager.credentials.password)
                .modifier(LoginText(isError: $isErrorAnimation, pressLogin: $pressLogin))
                .offset(CGSize(width: isErrorAnimation ? 5 : 0, height: 0))
            if pressLogin {
                ProgressView()
            }
            Text(authManager.errorDescription ?? "")
                .opacity(isShowMessageError ? 1 : 0)
                .foregroundColor(.red)
            LoginButton(isError: $isErrorAnimation,
                        isShowMessageError: $isShowMessageError,
                        pressLogin: $pressLogin)
            .padding(30)
            if authManager.isSavedCredential {
                switch authManager.biometryType {
                case .faceID:
                    Image(systemName: "faceid")
                        .foregroundColor(Color("DigitalCYAN"))
                        .onTapGesture {
                            Task.init {
                                await authManager.authenticateWithBiometrics()
                            }
                        }
                case .touchID:
                    Image(systemName: "touchid")
                        .foregroundColor(Color("DigitalCYAN"))
                        .onTapGesture {
                            Task.init {
                                await authManager.authenticateWithBiometrics()
                            }
                        }
                default:
                    Text("")
                }
            }
            Spacer()
            
        }
        .onAppear(){
            Task.init {
                if authManager.isSavedCredential {
                    await authManager.authenticateWithBiometrics()
                }
            }
        }
    }
}

struct LoginButton: View {
    
    @EnvironmentObject var authManager: AuthenticationManager
    @Binding var isError: Bool
    @Binding var isShowMessageError: Bool
    @Binding var pressLogin: Bool
    
    
    var body: some View {
        
        Button("Login") {
            pressLogin = true
            signIn()

        }
        .buttonStyle(.borderless)
        
    }
    
    func signIn() {
        authManager.authenticateWithCredentials() {
            if authManager.showError {
                let animationShake = Animation.easeInOut(duration: 0.1).repeatCount(5)
                let animationSlowApeare = Animation.linear(duration: 1.5)
                withAnimation(animationShake) {
                    isError = true
                }
                withAnimation(animationSlowApeare) {
                    isShowMessageError = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut) {
                        isError = false
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    withAnimation(animationSlowApeare) {
                        isShowMessageError = false
                    }
                }
            }
            pressLogin = false
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
struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(AuthenticationManager())
    }
}
