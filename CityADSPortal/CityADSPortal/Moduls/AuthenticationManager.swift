import Foundation
import LocalAuthentication

final class AuthenticationManager: ObservableObject {
    
    private var context = LAContext()
    private var network = NetworkService()
    @Published private(set) var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    @Published private(set) var isAuthenticated = false
    @Published private(set) var errorDescription: String?
    @Published var showError = false
    @Published var showAlertBio = false
    @Published var credentials = Credentials(username: "", password: "")
    private var savedCredentials = Credentials(username: "", password: "")
    @Published var isSavedCredential = false
    static let server = "www.cityADS.com"
    @Published var idUser = ""
    
    // On initialize of this class, get the biometryType
    init() {
        getBiometryType()
        do {
            try savedCredentials = getFromKeyChain()
            isSavedCredential = true
        }
        catch {
            isSavedCredential = false
        }
    }
    
    func getBiometryType() {
        // canEvaluatePolicy will let us know if the user's device supports biometrics authentication
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        // Getting the biometryType - in other words, if the device supports FaceID, TouchID, or doesn't support biometrics auth
        biometryType = context.biometryType
    }
    
    func authenticateWithBiometrics() async {
        // Resetting the LAContext so on the next login, biometrics are checked again
        context = LAContext()
        
        // Only evaluatePolicy if device supports biometrics auth
        if canEvaluatePolicy {
            let reason = "Log into your account"
            
            do {
                // evaluatePolicy will check if user is the device's owner, returns a boolean value that'll let us know if it successfully identified the user
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                
                // Only if it's a success, we'll set isAuthenticated to true
                if success {
                    DispatchQueue.main.async {
                        self.credentials = self.savedCredentials
                        print("isAuthenticated", self.isAuthenticated)
                    }
                }
            } catch {
                print(error.localizedDescription)
                
                // If we run into an error, we'll set the errorDescription, we'll show an alert and set the biometryType to none, so user can login with credentials
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.showError = true
                    self.biometryType = .none
                }
            }
        }
    }
    
    // Dummy function to sign in to the app - typically, you'd use a real authentication system like Sign in with Apple, Sign in with Google, Firebase Auth, or any other authentication service
    func authenticateWithCredentials(completion: @escaping () -> Void) {
        
        network.login(login: credentials.username, password: credentials.password) {[weak self] result in
            switch result.success {
            case true :
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                    self?.showAlertBio = !(self?.isSavedCredential ?? false) || self?.biometryType == LABiometryType.none
                    self?.idUser = result.id
                    completion()
                }
            case false:
                DispatchQueue.main.async {
                    self?.errorDescription = result.message
                    self?.showError = true
                    completion()
                    
                }
            }
        }
        
    }
    
    // Logout the user - just setting back isAuthenticated to false
    func logout() {
        isAuthenticated = false
    }
    
    func saveInKeyChain() throws {
        
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: AuthenticationManager.server,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
    }
    
    private func getFromKeyChain() throws -> Credentials  {
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: AuthenticationManager.server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }
        let credentials = Credentials(username: account, password: password)
        
        return credentials
    }
    
}

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
