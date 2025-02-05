//
//  StudentAttendanceView.swift
//  TestApp
//
//  Created by CyBeR on 05/02/2025.
//

import SwiftUI

struct Student: Hashable {
    var regno: String
    var name: String
    var percentage: Double
    var currentAttendance = "P"
}

struct StudentAttendanceView: View {
    @State var studentsList = [Student]()
    @State var attendanceOffset = ""

    func refrestList() {
        let db = AttendanceSystem()
        studentsList = db.getStudents()
    }
    var body: some View {
        NavigationView {
            VStack {
                List($studentsList, id: \.regno) { $stu in
                    VStack(alignment: .leading) {
                        Text("\(stu.regno)")
                            .foregroundStyle(.gray)
                        HStack {
                            Text("\(stu.name)")
                                .bold()
                            Spacer()
                            Text(
                                "\(String(format: "%.2f", stu.percentage.isNaN ? 0 : stu.percentage))%"
                            )
                            TextField("", text: $stu.currentAttendance)
                                .frame(width: 32, height: 32)
                                .padding(.leading)
                                .border(.black)
                        }
                    }

                }

            }.onAppear {
                refrestList()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(
                            destination: AddStudentView(),
                            label: {
                                Image(systemName: "plus")
                            })

                        Button {
                            let db = AttendanceSystem()
                            db.saveAttendance(
                                students: studentsList)
                            refrestList()
                        } label: {
                            Text("Submit")
                        }
                    }

                }
            }
        }
    }
}

#Preview {
    StudentAttendanceView()
}
