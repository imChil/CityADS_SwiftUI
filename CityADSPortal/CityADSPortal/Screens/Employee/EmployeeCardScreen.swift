
import SwiftUI

struct EmployeeCardScreen: View {
   
    var employee: Employee
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                avatar(inImage: employee.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("DigitalCYAN"), lineWidth: 5)
                        .shadow(radius: 3))
                    .padding(5)
                VStack{
                    Text(employee.name)
                        .lineLimit(2)
                        .font(.title2)
                        .padding(5)
                    Text(employee.jobName)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .shadow(radius: 1)
                }
            }
            VStack(alignment: .leading){
                HStack {Text("Office:")
                    Text(employee.department)}
                HStack {Text("Phone:")
                        Text(employee.phone)}
                HStack {Text("Email:")
                    Text(employee.email)}
                HStack {Text("Telegram:")
                    Text(employee.telegram)}
                Text("Bithday")
            }
            .padding(10)
            Spacer()
        }.padding(10)
    }
    
    func avatar(inImage: UIImage?) -> Image {
        return inImage == nil ? Image(systemName: "person") : Image(uiImage: inImage!)
    }
    
}

struct EmployeeCardScreen_Previews: PreviewProvider {
    static var previews: some View {
        let employee = Employee(id: "1", name: "Name name name", jobName: "Developer", department: "Core", email: "1@mail.ru", telegram: "@telegram", phone: "79253596165", skype: "")
        EmployeeCardScreen(employee: employee)
    }
}
