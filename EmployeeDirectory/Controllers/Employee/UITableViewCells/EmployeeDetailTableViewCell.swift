//
//  EmployeeDetailTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 05/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import UIKit

class EmployeeDetailTableViewCell: UITableViewCell {
    
    // MARK:- Interface Builder
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        self.bgView.layer.cornerRadius = 5.0
    }
    
    func loadData(headerText: String, detailText: String) {
        self.headerLabel.text = headerText
        self.detailLabel.text = detailText
    }
}
