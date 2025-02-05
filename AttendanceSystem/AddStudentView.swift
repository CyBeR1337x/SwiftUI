//
//  AddStudentView.swift
//  TestApp
//
//  Created by CyBeR on 05/02/2025.
//

import SwiftUI

struct AddStudentView: View {
    @State var regno: String = ""
    @State var name: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reg No")
            TextField("", text: $regno)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 35)
                .border(.gray, width: 1)
                .cornerRadius(3)
              
            Text("Name")
            TextField("", text: $name)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 35)
                .border(.gray, width: 1)
                .cornerRadius(3)
            
            HStack {
                Button(action: {
                    let d = AttendanceSystem()
                    d.insertStudent(regno: regno, name: name)
                    name = ""
                    regno = ""
                }, label: {
                    Text("Add")
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background(.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(7)
                })
                Button(action: {
                    name = ""
                    regno = ""
                }, label: {
                    Text("Clear")
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background(.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(7)
                })
            }
            .padding(.top)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddStudentView()
}
