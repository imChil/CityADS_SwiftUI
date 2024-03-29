

import SwiftUI

/**
 * Displays the calendar of MDPDayOfMonth items using MDPDayView views.
 */
struct MDPContentView: View {
    @EnvironmentObject var monthDataModel: MDPModel
    
    let cellSize: CGFloat = 30
    
    let columns = [
        GridItem(.fixed(42), spacing: 2),
        GridItem(.fixed(42), spacing: 2),
        GridItem(.fixed(42), spacing: 2),
        GridItem(.fixed(42), spacing: 2),
        GridItem(.fixed(42), spacing: 2),
        GridItem(.fixed(42), spacing: 2),
        GridItem(.fixed(42), spacing: 2)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            
            // Mon, Tue, etc.
            ForEach(1..<monthDataModel.dayNames.count, id: \.self) { index in
                Text(monthDataModel.dayNames[index].uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            // Sun
            Text(monthDataModel.dayNames[0].uppercased())
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            // The actual days of the month.
            ForEach(0..<monthDataModel.days.count, id: \.self) { index in
                if monthDataModel.days[index].day == 0 {
                    Text("")
                        .frame(minHeight: cellSize, maxHeight: cellSize)
                } else {
                    MDPDayView(dayOfMonth: monthDataModel.days[index])
//                        .foregroundColor(.red)
                }
            }
        }
        .padding(.bottom, 10)
    }
}

struct MonthContentView_Previews: PreviewProvider {
    static var previews: some View {
        MDPContentView()
            .environmentObject(MDPModel())
    }
}
