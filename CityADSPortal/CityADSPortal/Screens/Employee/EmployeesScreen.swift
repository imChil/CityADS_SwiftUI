
import SwiftUI

struct EmployeesScreen: View {

    let employService = Core()
    @State var employeeList : [Employee]
    @State var searchText = ""
    
    var body: some View {
        VStack{
            Text("")
            SearchBar(text: $searchText)
            List {
                ForEach(departments(employees: searchText.isEmpty ? employeeList : employeeList.filter({$0.name.contains(searchText) || $0.jobName.contains(searchText)})), id: \.self) { department in
                    Section {
                        ForEach(employeeList.filter({ searchText.isEmpty ? $0.department==department : ($0.name.contains(searchText) || $0.jobName.contains(searchText)) && $0.department==department})) { employee in
                                EmployeeCell(employeeData: employee)
                        }
                    } header: {
                        Text(department)
                    }
                }
            }
            .listStyle(.inset)
            .onAppear(){
                NetworkService.shared.getEmployees(){ result in
                    employeeList = convertEmployeeResult(employeeCodable: result.data)
                    fillImages()
                }
            }
        }
        
    }
    
    private func departments(employees: [Employee]) -> [String] {
       
        var result = [String]()
        for employee in employees {
            let index = result.firstIndex(of: employee.department)
            if index == nil {
                result.append(employee.department)
            }
        }
        
        return result
    }
    
    private func fillImages() {
        
        for (i, item) in employeeList.enumerated() {
            employService.getImage(id: item.id) { image in
                employeeList[i].avatar = image
            }
        }
        
    }
    
}

struct EmployeesScreen_Previews: PreviewProvider {
    static var previews: some View {
        let employee = Employee(id: "1", name: "Name", jobName: "Developer", department: "Core", email: "1@mail.ru", telegram: "@telegram")
        let employees = [employee]
        EmployeesScreen(employeeList: employees)
    }
}
