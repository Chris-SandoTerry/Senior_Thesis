//
//  DBHelper.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/12/24.
//

import Foundation
import SQLite3


class DBHelper 
{
    var db : OpaquePointer?
    var path : String = "myDb.sqlite"
    init() {
        self.db = createDB()
        self.createTable()
    }
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:
                                                        false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open (filePath.path, &db) != SQLITE_OK
        {
            print("There is error in creating DB")
            return nil
        }
        else
        {
            print ("Database is been created with path \(path)")
            return db
        }
    }
    
    
    func createTable()
    {
        let query = "CREATE TABLE IF NOT EXISTS grade(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, result TEXT, avg INTEGER, list TEXT);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("Table creation success")
            }
            else {
                print("Table creation fail")
            }
        
        }
        else {
            print ("Prepration fail")
        }
    }
    
}
