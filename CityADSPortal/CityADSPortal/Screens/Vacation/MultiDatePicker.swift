
import SwiftUI

/**
 * This component shows a date picker very similar to Apple's SwiftUI 2.0 DatePicker, but with a difference.
 * Instead of just allowing a single date to be picked, the MultiDatePicker also allows the user to select
 * a set of non-contiguous dates or a date range. It just depends on how this View is initialized.
 *
 * init(singleDay: Binding<Date> [,options])
 *      A single-date picker. Selecting a date de-selects the previous selection. Because the binding
 *      is a Date, there is always a selected date.
 *
 * init(anyDates: Binding<[Date]>, [,options])
 *      Allows multiple, non-continguous, dates to be selected. De-select a date by tapping it again.
 *      The binding array may be empty or it will be an array of dates selected in ascending order.
 *
 * init(dateRange: Binding<ClosedRange<Date>?>, [,options])
 *      Selects a date range. Tapping on a date marks it as the first date, tapping a second date
 *      completes the range. Tapping a date again resets the range. The binding will be nil unless
 *      two dates are selected, completeing the range.
 *
 * optional parameters to init() functions are:
 *  - includeDays: .allDays, .weekdaysOnly, .weekendsOnly
 *      Days not selectable are shown in gray and not selected.
 *  - minDate: Date? = nil
 *      Days before minDate are not selectable.
 *  - maxDate: Date? = nil
 *      Days after maxDate are not selectable.
 */
struct MultiDatePicker: View {
    
    // the type of picker, based on which init() function is used.
    enum PickerType {
        case singleDay
        case anyDays
        case dateRange
    }
    
    // lets all or some dates be elligible for selection.
    enum DateSelectionChoices {
        case allDays
        case weekendsOnly
        case weekdaysOnly
    }
    
    let id: String
    let imageManager = ImageService()
    let calendar = Calendar.current
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @StateObject var monthModel: MDPModel
    @State var vacations = [Vacation]()
    @State private var startAnimation = false
    @State private var scale: CGFloat = 1
    
    
    private var availibleDays: Int {
        guard let start = monthModel.selections.first else { return monthModel.availableDays}
        guard let end = monthModel.selections.last else { return monthModel.availableDays}
        let d = (calendar.dateComponents([.day], from: start, to: end).day ?? 0)  + 1
        return startAnimation ? monthModel.availableDays - d : monthModel.availableDays
    }
    
    // selects only a single date
    
    init(id: String,
         singleDay: Binding<Date>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        self.id = id
        _monthModel = StateObject(wrappedValue: MDPModel(singleDay: singleDay, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    // selects any number of dates, non-contiguous
    
    init(id: String,
         anyDays: Binding<[Date]>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        self.id = id
        _monthModel = StateObject(wrappedValue: MDPModel(anyDays: anyDays, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    // selects a closed date range
    
    init(id: String,
         dateRange: Binding<ClosedRange<Date>?>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        self.id = id
        _monthModel = StateObject(wrappedValue: MDPModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Color.clear
                    .frame(width: 25, height: 25)
                    .padding(12)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.green, lineWidth: 4))
                    .animatingOverlay(for: availibleDays)
                    .padding(.horizontal, 20)
                    .scaleEffect(scale)
                    .animation(.spring(), value: scale)
                    .onTapGesture(perform: someAnimation)
                    .onReceive(timer) { _ in
                        if startAnimation {
                            scale = scale == 1.3 ? 1 : 1.3
                        } else {
                            scale = 1
                        }
                    }
            }
            
            MDPMonthView()
                .environmentObject(monthModel)
            
            HStack {
                Button("OK") {
                    cteateNewVacation()
                    someAnimation()
                }
                Button("Cancel") {
                    someAnimation()
                }
            }
            .opacity(startAnimation && monthModel.selections.count>0 ? 1 : 0)
            .animation(.spring())
            
            List{
                ForEach(vacations) { vacation in
                    if calendar.component(.month, from: monthModel.controlDate) == calendar.component(.month, from: vacation.start) || calendar.component(.month, from: monthModel.controlDate) == calendar.component(.month, from: vacation.end) {
                        VacationCell(avatar: vacation.avatar, start: vacation.start, end: vacation.end)
                            .environmentObject(monthModel)
                    }
                }
            }
            
            .onAppear(){
                NetworkService.shared.getVacations(id: id) {result in
                    DispatchQueue.main.async {
                        self.monthModel.availableDays = result.data.countDays
                        self.vacations = convertVacationResult(vacationsCodable: result.data.vacations)
                    }
                }
            }
        }
    }
    
    private func someAnimation() {
        startAnimation.toggle()
        monthModel.selections.removeAll()
    }
    
    private func cteateNewVacation() {
        
        guard let start = monthModel.selections.first else { return }
        guard let end = monthModel.selections.last else { return }
        
        var vacation = Vacation(id: self.vacations.count+1, idEmployee: id, start: start, end: end)
        imageManager.getImage(id: id) { avatar in
            vacation.avatar = avatar
        }
        self.vacations.append(vacation)
        self.monthModel.availableDays = availibleDays
        
    }
    
}

struct MultiDatePicker_Previews: PreviewProvider {
    @State static var oneDay = Date()
    @State static var manyDates = [Date]()
    @State static var dateRange: ClosedRange<Date>? = nil
    
    static var previews: some View {
        ScrollView {
            VStack {
                MultiDatePicker(id: "e8f865a3-a66e-11eb-80bc-00155d043f13", singleDay: $oneDay, includeDays: .weekdaysOnly)
                MultiDatePicker(id: "e8f865a3-a66e-11eb-80bc-00155d043f13", anyDays: $manyDates)
                MultiDatePicker(id: "e8f865a3-a66e-11eb-80bc-00155d043f13", dateRange: $dateRange)
            }
        }
    }
}
