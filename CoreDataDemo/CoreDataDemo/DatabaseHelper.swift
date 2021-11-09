//
//  DatabaseHelper.swift
//  CoreDataDemo
//
//  Created by web-bunny on 23/01/19.
//  Copyright © 2019 web-bunny. All rights reserved.
//


//Queries will be here(Database Part)
import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    
    // Instance of Databasehelper class for using property of this class in every viewController
    static  var shareInstance = DatabaseHelper()
    
    //Declare globally because it is use in every Save/Edit/delete syntax(Hirarchy Explain how coredata works)
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var student = [Student]()
    
    //Save Data In CoreData
    func saveData(object: [String : String]){
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context!) as! Student
        student.name = object["name"]
        student.address = object["address"]
        student.city = object["city"]
        student.mobile = object["mobile"]
        do{
            try context?.save()
            print("Saved in Database")
        }catch{
            print("Data is not save")
        }
    }
    
    //Fetching Data From CoreDatabase
    func getStudentData() ->[Student] {
      //  var student = [Student]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        do{
            student = try context?.fetch(fetchRequest) as! [Student]
            print("Got Data From Database")
        }catch{
            print("can't get data")
        }
        return student
    }
    
    //Delete Data
    func deleteData(index:Int) ->[Student]{
        var student = getStudentData()
        context?.delete(student[index])
        student.remove(at: index)
         print("Row Removed")
        do{
          try context?.save()
           
        }catch{
            print("Cant Delete data\(error)")
        }
        return student
    }
    
    //Edit and Update
    func EditData(object:[String:String], i:Int){
        
        var student = getStudentData()
        student[i].name = object["name"]
        student[i].address = object["address"]
        student[i].city = object["city"]
        student[i].mobile = object["mobile"]
        
        do{
            try context?.save()
            print("Data is Updated")
        }catch{
            print("Data is not edit")
        }
    }
    
 }
