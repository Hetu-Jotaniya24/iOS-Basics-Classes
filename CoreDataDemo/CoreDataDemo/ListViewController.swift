//
//  ListViewController.swift
//  CoreDataDemo
//
//  Created by web-bunny on 23/01/19.
//  Copyright © 2019 web-bunny. All rights reserved.
//

import UIKit

protocol DataPass {
    //index : will carry the indexpath of the selected row
    //isEdit : if true than edit else save
    func datafromListvc(object:[String:String],index:Int, isEdit:Bool)
    }


class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var student = [Student]()
    
    //Assign Delegate to Protocol for Accesing it's Method
    var delegate: DataPass!
    
    @IBOutlet weak var myTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        student = DatabaseHelper.shareInstance.getStudentData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.lblName.text = student[indexPath.row].name
        cell.lblAddress.text = student[indexPath.row].address
        cell.lblCity.text = student[indexPath.row].city
        cell.lblMobile.text = student[indexPath.row].mobile
        //OR (CodeReduction) from Custom cell
        //cell.student = [indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            student = DatabaseHelper.shareInstance.deleteData(index: indexPath.row)
           self.myTableview.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = ["name":student[indexPath.row].name,"address":student[indexPath.row].address,"city":student[indexPath.row].city,"mobile":student[indexPath.row].mobile]
        
        delegate.datafromListvc(object:  dict as! [String:String], index: indexPath.row, isEdit:true )
        self.navigationController?.popViewController(animated: true)
    }

}
