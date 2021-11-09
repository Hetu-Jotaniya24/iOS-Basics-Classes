//
//  CustomCell.swift
//  CoreDataDemo
//
//  Created by web-bunny on 23/01/19.
//  Copyright © 2019 web-bunny. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    //this will directly connect the lable and coredata attribute(CodeReduction)
//    var student : Student!{
//        didset {
//            lblName.text = student.name
//            lblAddress.text = student.address
//            lblCity.text = student.city
//            lblMobile.text = student.mobile
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
