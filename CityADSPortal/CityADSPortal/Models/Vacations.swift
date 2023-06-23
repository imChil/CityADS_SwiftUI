
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
    
}

struct Vacation: Identifiable {
    let id: Int
    let idEmployee: String
    let start: Date
    let end: Date
    var avatar: UIImage?
    
}

func convertVacationResult(vacationsCodable: [VacationCodable]) -> [Vacation] {
    
    let imageManager = ImageService()
    var vacationsArray : [Vacation] = []
    
    for item in vacationsCodable {
        var vacation = Vacation(id: item.id, idEmployee: item.idEmployee, start: DateFromString(item.start), end: DateFromString(item.end))
        imageManager.getImage(id: item.idEmployee) { avatar in
            vacation.avatar = avatar
        }
        vacationsArray.append(vacation)
    }
    
    return vacationsArray
}

func DateFromString(_ dateFromAPI: String) -> Date {
    
    let formater = DateFormatter()
    formater.dateStyle = .short
    formater.timeStyle = .none
    formater.dateFormat = "yyyy-MM-dd"
    let result = formater.date(from: dateFromAPI)
    
    return result ?? Date()
    
}
