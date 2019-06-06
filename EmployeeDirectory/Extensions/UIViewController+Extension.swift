//
//  UIViewController+Extension.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 04/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import Foundation
import UIKit

private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

extension UIViewController {
    func addTitle(title:String){
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 17.0)!
        self.navigationItem.titleView = titleLabel
    }
    
    func showAlert(titleString title:String = "", messageString message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        })
        alertController.addAction(action)
        self.present(alertController, animated:true, completion:nil)
    }
}

extension UIViewController {
    
    public func showActivityIndicatorView() {
        
        if let indicator = self.view.subviews.last as? UIActivityIndicatorView , indicator === activityIndicator {
            if  activityIndicator.isAnimating {
                return
            }
            else {
                activityIndicator.startAnimating()
            }
        }
        else {
            self.view.isUserInteractionEnabled = false
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = UIColor.black
            
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            self.view.addConstraints([xConstraint, yConstraint])
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    public func hideActivityIndicatorView() {
        
        if let indicator = self.view.subviews.last as? UIActivityIndicatorView , indicator === activityIndicator {
            if activityIndicator.isAnimating {
                activityIndicator.stopAnimating()
            }
            self.view.isUserInteractionEnabled = true
            activityIndicator.removeFromSuperview()
        }
    }
}
