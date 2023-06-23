
import SwiftUI

struct VacationScreen: View {
    
    let id: String
    @State var dateRange: ClosedRange<Date>? = nil

    
    var body: some View {
        MultiDatePicker(id: id, dateRange: $dateRange, minDate: Date().dayBefore)
    }
}

struct VacationScreen_Previews: PreviewProvider {
    static var previews: some View {
        VacationScreen(id: "e8f865a3-a66e-11eb-80bc-00155d043f13")
    }
}
