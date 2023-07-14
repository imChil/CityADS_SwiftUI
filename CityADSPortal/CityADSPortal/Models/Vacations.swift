
import Foundation
import SwiftUI

struct VacationsResult: Codable {
    let countDays: Int
    let vacations: [VacationCodable]
    
    enum CodingKeys : String, CodingKey {
        case countDays = "CountDays"
        case vacations = "Vacations"
    }
}
    

struct VacationCodable: Identifiable, Codable {
    let id: Int
    let idEmployee: String
    let start: String
    let end: String
    let name: String
    let jobName: String
    let department: String
    
}

struct Vacation: Identifiable {
    let id: Int
    let idEmployee: String
    let start: Date
    let end: Date
    let name: String
    let jobName: String
    let department: String
    var avatar: UIImage?
    var isActive = false
    
}

func convertVacationResult(vacationsCodable: [VacationCodable]) -> [Vacation] {
    
    let imageManager = ImageService()
    var vacationsArray : [Vacation] = []
    
    for item in vacationsCodable {
        var vacation = Vacation(id: item.id,
                                idEmployee: item.idEmployee,
                                start: item.start.convertToDate(),
                                end: item.end.convertToDate(),
                                name: item.name,
                                jobName: item.jobName,
                                department: item.department)
        imageManager.getImage(id: item.idEmployee) { avatar in
            vacation.avatar = avatar
        }
        vacationsArray.append(vacation)
    }
    
    return vacationsArray
}

