//
//  Login.swift
//  CityADSPortal
//
//  Created by  Pavel Chilin on 19.06.2023.
//

import Foundation
import SwiftUI

final class Login: ObservableObject {
    
    @EnvironmentObject var authManager : AuthenticationManager
    @Published var isError = false
    @Published var isShowMessageError = false
    @Published var pressLogin = false
    
    func signIn() {

        authManager.authenticateWithCredentials { [weak self] in
            
            self?.pressLogin = true
            
            if ((self?.authManager.showError) != nil) {
                let animationShake = Animation.easeInOut(duration: 0.1).repeatCount(5)
                let animationSlowApeare = Animation.linear(duration: 1.5)
                withAnimation(animationShake) {
                    self?.isError = true
                }
                withAnimation(animationSlowApeare) {
                    self?.isShowMessageError = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut) {
                        self?.isError = false
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    withAnimation(animationSlowApeare) {
                        self?.isShowMessageError = false
                    }
                }
            }
            self?.pressLogin = false
        }
    }
    
}
