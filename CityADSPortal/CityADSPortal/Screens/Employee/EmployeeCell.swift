
import SwiftUI

struct EmployeeCell: View {
    var employeeData : Employee
    @State var showDetail = false
    var body: some View {
        
        HStack {
            avatar(inImage: employeeData.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("DigitalCYAN"), lineWidth: 4))
                .padding(.horizontal, 5)
                
            VStack(alignment: .leading) {
                Text(employeeData.name)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
                Text(employeeData.jobName)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.callout)
            }
            .padding(.horizontal, 2)
        }.onTapGesture(){
            withAnimation(.spring()){
                showDetail.toggle()
            }
        }
        .sheet(isPresented: $showDetail) {
            EmployeeCardScreen(employee: employeeData)
        }
        
    }
        
}

func avatar(inImage: UIImage?) -> Image {
    return inImage == nil ? Image(systemName: "person") : Image(uiImage: inImage!)
}

struct EmployeeCell_Previews: PreviewProvider {
    static var previews: some View {
        let employee = Employee(id: "1", name: "Name name name", jobName: "Developer", department: "Core", email: "1@mail.ru", telegram: "@telegram", phone: "79253596165", skype: "", bday: Date())
        EmployeeCell(employeeData: employee)
    }
}
