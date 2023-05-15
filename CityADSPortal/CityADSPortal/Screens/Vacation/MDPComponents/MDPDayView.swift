
import SwiftUI

/**
 * MDPDayView displays the day of month on a MDPContentView. This a button whose color and
 * selectability is determined from the MDPDayOfMonth in the MDPModel.
 */
struct MDPDayView: View {
    @EnvironmentObject var monthDataModel: MDPModel
    let cellSize: CGFloat = 30
    var dayOfMonth: MDPDayOfMonth
    
    // outline "today"
    private var strokeColor: Color {
        dayOfMonth.isToday ? Color.accentColor : Color.clear
    }
    
    private var weekendColor: Color {
        dayOfMonth.index == 5 || dayOfMonth.index == 6 || dayOfMonth.index == 12 || dayOfMonth.index == 13 || dayOfMonth.index == 19 || dayOfMonth.index == 20 || dayOfMonth.index == 26 || dayOfMonth.index == 27 || dayOfMonth.index == 33 || dayOfMonth.index == 34 || dayOfMonth.index == 41 || dayOfMonth.index == 42 ? Color.red : Color.primary
    }
    
    // filled if selected
    private var fillColor: Color {
        monthDataModel.isSelected(dayOfMonth) ? Color.blue.opacity(0.55) : Color.clear
    }
    
    // reverse color for selections or gray if not selectable
    private var textColor: Color {
        if dayOfMonth.isSelectable {
            return monthDataModel.isSelected(dayOfMonth) ? Color.white : weekendColor
        } else {
            return Color.gray
        }
    }
    
    private func handleSelection() {
        if dayOfMonth.isSelectable {
//            monthDataModel.selectDay(dayOfMonth)
        }
    }
    
    var body: some View {
        Button( action: {handleSelection()} ) {
            Text("\(dayOfMonth.day)")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(textColor)
                .frame(minHeight: cellSize, maxHeight: cellSize)
                .background(
                    Circle()
                        .stroke(strokeColor, lineWidth: 1)
                        .background(Circle().foregroundColor(fillColor))
                        .frame(width: cellSize, height: cellSize)
                )
        }
//        .foregroundColor(Color(UIColor.systemBackground))
    }
}

struct DayOfMonthView_Previews: PreviewProvider {
    static var previews: some View {
        MDPDayView(dayOfMonth: MDPDayOfMonth(index: 0, day: 1, date: Date(), isSelectable: true, isToday: true))
            .environmentObject(MDPModel())
    }
}
