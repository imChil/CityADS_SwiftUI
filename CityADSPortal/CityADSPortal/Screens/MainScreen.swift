
import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView() {
            EmployeesScreen()
                .tabItem(){
                    Label("Employees", systemImage: "person")
                }
            .tag(0)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
