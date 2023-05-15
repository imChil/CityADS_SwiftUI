
import SwiftUI

struct MainScreen: View {
    let idUser: String
    var body: some View {
        TabView() {
                EmployeesScreen()
                    .tabItem(){
                        Label("Employees", systemImage: "person")
                    }
                    .tag(0)
                VacationScreen(id: idUser)
                .tabItem(){
                    Label("Vacation", systemImage: "calendar")
                }
                .tag(1)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(idUser: "88f485c2-0c5f-11eb-80b6-00155d043f13")
    }
}
