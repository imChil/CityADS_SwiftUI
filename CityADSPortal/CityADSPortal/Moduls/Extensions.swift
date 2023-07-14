
import Foundation
import SwiftUI

extension Image {
    
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self = .init(uiImage: image)
    }
    
}

extension Date {
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func convertToString(withFormat dateFormat : String = "dd.MM.yyyy") -> String {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        formater.dateFormat = dateFormat
        return formater.string(from: self)
    }
    
}

extension String {
    
    func convertToDate() -> Date {
        
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        formater.dateFormat = "yyyy-MM-dd"
        let result = formater.date(from: self)
        
        return result ?? Date()
        
    }
    
}
