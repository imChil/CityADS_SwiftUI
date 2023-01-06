//
//  LoginScreen.swift
//  CityADSPortal
//
//  Created by  Pavel Chilin on 13.12.2022.
//

import SwiftUI

struct LoginScreen: View {
    
    @State var login: String = ""
    @State var password: String = ""
    @State var isErrorAnimation: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            Image("CAlogo")
            Spacer()
            TextField("Login", text: $login)
                .modifier(LoginText(isError: $isErrorAnimation))
            
            SecureField(text: $password, label: {
                Label("password", systemImage: "key")
            })
            .modifier(LoginText(isError: $isErrorAnimation))
            .offset(CGSize(width: isErrorAnimation ? 5 : 0, height: 0))
            LoginButton(login: $login, password: $password, isError: $isErrorAnimation)
                .padding(30)
            Spacer()
            
        }
    }
}

struct LoginButton: View {
    
    @Binding var login: String
    @Binding var password: String
    @Binding var isError: Bool
    @State var loginSucsses = false
    
    let network = NetworkService.shared
    
    var body: some View {
        
        Button("Login") {
            signIn()
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: $loginSucsses) {
            MainScreen()
        }
    }
    
    func signIn() {
        network.login(login: login, password: password) {result in
            switch result.success {
            case true :
                loginSucsses = true
            case false:
                let animation = Animation.easeInOut(duration: 0.1).repeatCount(5)
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
    static let screenWidth = UIScreen.main.bounds.size.width
    static let textfildsWidth = screenWidth/1.6  >= 220 ? screenWidth/1.6 : 220
    
    func body(content: Content) -> some View {
        let colorBorder = isError ? Color(.red) : Color("DigitalCYAN")
        content
            .frame(width: LoginText.textfildsWidth, height: 30)
            .padding(.leading, 10)
            .disableAutocorrection(true)
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
    }
}
