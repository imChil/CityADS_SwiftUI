
import SwiftUI

struct VacationScreen: View {
    
    let id: String
    @State var vacations = [Vacation]()
    @State var manyDates = [Date]()
    @State var daysCount = 0
    
    var body: some View {
        VStack{
            Text(String(daysCount))
            MultiDatePicker(anyDays: $manyDates)
            List{
                ForEach(vacations) { vacation in
                    VacationCell(avatar: vacation.avatar, start: vacation.start, end: vacation.end)
                }
            }
            .onAppear(){
                NetworkService.shared.getVacations(id: id) {result in
                    self.daysCount = result.data.countDays
                    self.vacations = convertVacationResult(vacationsCodable: result.data.vacations)
                }
            }
        }
    }
}

struct VacationScreen_Previews: PreviewProvider {
    static var previews: some View {
        VacationScreen(id: "e8f865a3-a66e-11eb-80bc-00155d043f13")
    }
}
