
import SwiftUI

struct VacationCell: View {
    var avatar: UIImage?
    let start: Date
    let end: Date
    @EnvironmentObject var monthDataModel: MDPModel
    
    var body: some View {
        HStack{
            avatar(inImage: avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("DigitalCYAN"), lineWidth: 2))
                .padding(.horizontal, 5)
            Text(FormateStringFromDate(date: start))
            Text(" - ")
            Text(FormateStringFromDate(date: end))
        }
        .onTapGesture {
            withAnimation(){
                monthDataModel.selections.removeAll()
                monthDataModel.selections = [start, end]
            }
        }
        
    }
    
    func FormateStringFromDate(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        formater.dateFormat = "dd.MM.yyyy"
        return formater.string(from: date)
    }
    
    func avatar(inImage: UIImage?) -> Image {
        return inImage == nil ? Image(systemName: "person") : Image(uiImage: inImage!)
    }
}

struct VacationCell_Previews: PreviewProvider {
    static var previews: some View {
        VacationCell(start: Date(), end: Date())
            .environmentObject(MDPModel())
    }
}
