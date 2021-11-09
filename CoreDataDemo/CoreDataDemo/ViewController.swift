//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by web-bunny on 23/01/19.
//  Copyright © 2019 web-bunny. All rights reserved.
//

//Implementation of operation will be here

import UIKit

class ViewController: UIViewController,DataPass {
    
   
    

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    // i : will store index value of selected row arriving from ListVC
    var i = Int()

    //for storing value got in isEdit
    var isUpdate = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveBtnTapped(_ sender: Any) {
        let dict = ["name":txtName.text, "address":txtAddress.text, "city":txtCity.text, "mobile":txtMobile.text]
        
        if isUpdate{
            DatabaseHelper.shareInstance.EditData(object: dict as! [String:String], i: i)
        }else{
            DatabaseHelper.shareInstance.saveData(object: dict as! [String : String])
        }
        
               
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listVC.delegate = self
        self.navigationController?.pushViewController(listVC, animated: true)
        
    }
    
    @IBAction func ShowDataTapped(_ sender: Any) {
        
        
    }
    //Mark:- Edit and Update
    //Delegate Method of ListVC (Protocol)
    func datafromListvc(object: [String : String], index:Int, isEdit: Bool) {
        
        txtName.text = object["name"]
        txtAddress.text = object["address"]
        txtCity.text = object["city"]
        txtMobile.text = object["mobile"]
        
        // i = indexpath.row of selected ListVC for Edit and Update
        i = index
        isUpdate = isEdit
    }
}

