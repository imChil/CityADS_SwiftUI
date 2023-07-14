
import Foundation
import SwiftUI

final class EmployeeService: ObservableObject {
    
    private let imageManager = ImageService()
    private let networkService = NetworkService()
    @Published var employeeList = [Employee]()
    
    func getImage(id: String, completion: @escaping (UIImage) -> Void) {
        
        imageManager.getImage(id: id, completion: completion)
        
    }
    
    func getEmployees() {
        networkService.getEmployees(){ [weak self] result in
            DispatchQueue.main.async {
                self?.employeeList = convertEmployeeResult(employeeCodable: result.data)
                self?.fillImages()
            }
        }
    }
    
    func filter(searchText: String) -> [Employee] {
        
        
        return searchText.isEmpty ? employeeList : employeeList.filter({$0.name.uppercased().contains(searchText.uppercased()) || $0.jobName.uppercased().contains(searchText.uppercased())})
        
    }
    
    private func fillImages() {
        
        for (i, item) in employeeList.enumerated() {
            getImage(id: item.id) { [self] image in
                employeeList[i].avatar = image
            }
        }
        
    }
}
