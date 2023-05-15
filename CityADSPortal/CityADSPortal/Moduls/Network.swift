
import Foundation
import SwiftUI

class NTLMAuthenticationSessionTaskDelegate : NSObject, URLSessionTaskDelegate {
    
  let credential:URLCredential
    
  init(user:String, password:String) {
    self.credential = URLCredential(user: user, password: password, persistence: URLCredential.Persistence.forSession)
  }

  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  didReceive challenge: URLAuthenticationChallenge,
                  completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    completionHandler(.useCredential,credential)
  }
}


final class NetworkService {
    
    static let shared = NetworkService()
    
    private var session = URLSession(configuration: URLSessionConfiguration.default, delegate: NTLMAuthenticationSessionTaskDelegate(user:"p.chilin", password:"Chil66621)"), delegateQueue: nil)
    
    private func request(url: String, completion: @escaping (Data) -> Void) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let parsData = data else { return }
            
            completion(parsData)
            
        }
        
        task.resume()
    }
    
    func login(login: String, password: String, completion: @escaping (LoginResponse) -> Void) {
        
        let param = "?login=\(login)&password=\(password)"
        let url = "https://1c.cityads.com/LF/hs/portal/login\(param)"
        
        request(url: url) { parsData in
            if let loginResult = try? JSONDecoder().decode(LoginResponse.self, from: parsData) {
                    completion(loginResult)
            }
        }
    }
    
    func getEmployees(completion: @escaping (EmployeesResponse) -> Void) {
        
        let url = "https://1c.cityads.com/LF/hs/portal/emploeelist"
        
        request(url: url) { parsData in
            if let result = try? JSONDecoder().decode(EmployeesResponse.self, from: parsData) {
                    completion(result)
            }
        }
    }
    
    func getVacations(id: String, completion: @escaping (VacationsResponse) -> Void) {
        
        let url = "https://1c.cityads.com/LF/hs/portal/vacations?id=\(id)"
        
        request(url: url) { parsData in
            if let result = try? JSONDecoder().decode(VacationsResponse.self, from: parsData) {
                    completion(result)
            }
        }
    }
    
    func getImage(id: String, completion: @escaping (UIImage) -> Void) {
        
        let url = "https://1c.cityads.com/LF/hs/portal/emploeeimage?id=\(id)"
        
        request(url: url) { parsData in

            if let image = UIImage(data: parsData) {
                    completion(image)
            }
        }
    }
   
}


struct LoginResponse: Codable {
    
    var success : Bool
    var message : String
    var id : String
    
    enum CodingKeys : String, CodingKey {
        case success = "Success"
        case message = "Message"
        case id = "ID"
    }
    
}

struct EmployeesResponse: Codable {
    
    var success : Bool
    var message : String
    var data : [EmployeeCodable]
    
    enum CodingKeys : String, CodingKey {
        case success = "Success"
        case message = "Message"
        case data = "Data"
    }
    
}

struct VacationsResponse: Codable {
    
    var success : Bool
    var message : String
    var data : VacationsResult
    
    enum CodingKeys : String, CodingKey {
        case success = "Success"
        case message = "Message"
        case data = "Data"
    }
    
}
