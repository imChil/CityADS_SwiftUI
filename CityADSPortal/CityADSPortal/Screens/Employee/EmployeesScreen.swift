
import SwiftUI

struct EmployeesScreen: View {
    
    @StateObject var employeeService = EmployeeService()
    @State var searchText = ""
    
    var body: some View {
        VStack{
            Text("")
            SearchBar(text: $searchText)
            if employeeService.employeeList.count == 0 {
                ProgressView()
            }
            List {
                ForEach(departments(employees: employeeService.filter(searchText: searchText)).sorted(), id: \.self) { department in
                    Section {
                        ForEach(employeeService.filter(searchText: searchText).filter({ $0.department==department })) { employee in
                            EmployeeCell(employeeData: employee)
                        }
                    } header: {
                        Text(department)
                    }
                }
            }
            .listStyle(.inset)
            .onAppear(){
                employeeService.getEmployees()
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    }

    private func departments(employees: [Employee]) -> Set<String> {
        
        var result = Set<String>()
        for employee in employees {
            result.insert(employee.department)
        }
        
        return result
    }
    
}

struct EmployeesScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesScreen()
    }
}
