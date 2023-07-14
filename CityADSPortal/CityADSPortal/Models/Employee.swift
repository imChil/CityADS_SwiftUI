
import Foundation
import SwiftUI

struct EmployeeCodable: Codable {
    let id: String
    let name: String
    let jobName: String
    let department: String
    let email: String
    let telegram: String
    let phone: String
    let skype: String
    let bday: String
}
    

struct Employee: Identifiable {
    let id: String
    let name: String
    let jobName: String
    let department: String
    let email: String
    let telegram: String
    let phone: String
    let skype: String
    var avatar: UIImage?
    let bday: Date
}


func convertEmployeeResult(employeeCodable: [EmployeeCodable]) -> [Employee] {
    
    var employeeArray : [Employee] = []
    
    for item in employeeCodable {
        let employee = Employee(id: item.id,
                                name: item.name,
                                jobName: item.jobName,
                                department: item.department,
                                email: item.email,
                                telegram: item.telegram,
                                phone: item.phone,
                                skype: item.skype,
                                avatar: nil,
                                bday: item.bday.convertToDate())
        employeeArray.append(employee)
    }
    
    return employeeArray
}
