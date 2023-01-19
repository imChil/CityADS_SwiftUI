import LocalAuthentication
import SwiftUI

class Biometric {
    
    let context = LAContext()
    var error: NSError?
    
    func authenticate(completion: @escaping (Bool) -> Void) {

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                completion(success)
            }
            
        } else {
            completion(false)
        }
    }
    
}
