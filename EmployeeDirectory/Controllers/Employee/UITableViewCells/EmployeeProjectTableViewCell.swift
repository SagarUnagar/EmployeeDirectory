//
//  EmployeeProjectTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 05/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import UIKit

class EmployeeProjectTableViewCell: UITableViewCell {

    // MARK:- Interface Builder
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.bgView.layer.cornerRadius = 5.0
    }
    
    func loadData(titleText: String) {
        self.titleLabel.text = titleText
    }
}
