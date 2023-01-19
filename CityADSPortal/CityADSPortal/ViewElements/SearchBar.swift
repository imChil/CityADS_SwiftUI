import SwiftUI
 
struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text, onEditingChanged: {_ in isEditing=true})
                .autocorrectionDisabled()
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
        }.overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)

                    Button(action: {
                        text = ""
                        isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 20)
                    .opacity(isEditing || text != "" ? 1 : 0)
            }
        )
    }
}

