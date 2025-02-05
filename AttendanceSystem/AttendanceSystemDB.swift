//
//  AttendanceSystem.swift
//  TestApp
//
//  Created by CyBeR on 05/02/2025.
//

import Foundation
import SQLite

class AttendanceSystem {
    var db: Connection?
    
    
    // Student Table
    let students = Table("student")
    let regno = SQLite.Expression<String>("regno")
    let name = SQLite.Expression<String>("name")
    
    // StudentAttendance Table
    let students_attendance = Table("studentAttendance")
    let att_regno = SQLite.Expression<String>("regno")
    let att_status = SQLite.Expression<String>("status")
    let att_date = SQLite.Expression<Date>("date")
    
    
    init() {
        connectToDb()
        createTables()
    }
    
    func insertStudent(regno: String, name: String) {
        guard let db = db else {
            return
        }
        let stmt = students.insert(self.regno <- regno, self.name <- name)
        try! db.run(stmt)
    }
    
    func getStudents() -> [Student] {
        guard let db = db else {
            return []
        }
        var studentsList = [Student]()
        do {
            
            let students = self.students.select(self.regno, self.name)
            let totalClassesHeld = try db.scalar(self.students_attendance.select(self.att_date.distinct.count))
            
            for row in (try db.prepare(students)) {
                let row_regno = row[self.regno]
                let row_name = row[self.name]
                
                // Percentage Calculation
                
                let totalP = try db.scalar(self.students_attendance.select(self.att_status.count)
                    .where(self.att_regno == row_regno && self.att_status == "P"))
                
                studentsList.append(Student(regno: row_regno, name: row_name, percentage: (Double(totalP) * 100.0 / Double(totalClassesHeld))))
            
            }
        } catch {
            print(error)
        }
        
        return studentsList
    }
    
    func saveAttendance(students: [Student]) {
        guard let db = db else {
            return
        }
        var arr: [[Setter]] = []
        let currentDate = Date.now
        for i in students {
            arr.append([att_regno <- i.regno, att_status <- i.currentAttendance, att_date <- currentDate])
        }
        
        try! db.run(students_attendance.insertMany(arr))
    }
    
    func createTables() {
        guard let db = db else {
            return
        }
        
        var stmt = students.create(ifNotExists: true) { t in
            t.column(self.regno, primaryKey: true)
            t.column(self.name)
        }
        
        try! db.run(stmt)
        
        stmt = students_attendance.create(ifNotExists: true) { t in
            t.column(self.att_regno)
            t.column(self.att_status)
            t.column(self.att_date)
        }
        
        try! db.run(stmt)
        
//        try! db.run(students.insertMany([
//            [regno <- "2021-ARID-4001", name <- "Ali Khan"],
//            [regno <- "2021-ARID-4002", name <- "Sara Ahmed"],
//            [regno <- "2021-ARID-4003", name <- "Bilal Raza"]
//        ]))
//        
//        try!  db.run(students_attendance.insertMany([
//            [att_regno <- "2021-ARID-4001", att_status <- "P", att_date <- Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!],
//            [att_regno <- "2021-ARID-4002", att_status <- "A", att_date <- Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!],
//            [att_regno <- "2021-ARID-4003", att_status <- "P", att_date <- Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!],
//            [att_regno <- "2021-ARID-4001", att_status <- "A", att_date <- Date.now],
//            [att_regno <- "2021-ARID-4002", att_status <- "P", att_date <- Date.now],
//            [att_regno <- "2021-ARID-4003", att_status <- "P", att_date <- Date.now]
//        ]))
    }
    

    func connectToDb() {
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fullPath = path.appendingPathComponent("attendance.sqlite3")
            print(path)
            db = try Connection(fullPath.path)
            
        } catch {
            print(error)
        }
    }
}
