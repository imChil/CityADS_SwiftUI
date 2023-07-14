
import SwiftUI

struct VacationCell: View {

    @Binding var data: Vacation
    @Binding var allVacations: [Vacation]
    
    @EnvironmentObject var monthDataModel: MDPModel
    
    var body: some View {
        VStack{
            HStack{
                avatar(inImage: data.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("DigitalCYAN"), lineWidth: 2))
                    .padding(.horizontal, 5)
                Text(data.start.convertToString())
                Text(" - ")
                Text(data.end.convertToString())
            }
            if data.isActive {
                Text(data.name)
            }
        }
        .onTapGesture {
            for i in allVacations {
                allVacations[i.id-1].isActive = false
            }
            withAnimation(){
                data.isActive = true
                monthDataModel.selections.removeAll()
                monthDataModel.selections = [data.start, data.end]
            }
        }
        
    }
    
    func avatar(inImage: UIImage?) -> Image {
        return inImage == nil ? Image(systemName: "person") : Image(uiImage: inImage!)
    }
}

struct VacationCell_Previews: PreviewProvider {
    @State static var item = Vacation(id: 1, idEmployee: "e8f865a3-a66e-11eb-80bc-00155d043f13", start: Date(), end: Date(), name: "", jobName: "", department: "")
    @State static var vatations = [Vacation]()
    static var previews: some View {
        VacationCell(data: $item, allVacations: $vatations)
            .environmentObject(MDPModel())
    }
}
