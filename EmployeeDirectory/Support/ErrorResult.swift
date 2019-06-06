//
//  ErrorResult.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 03/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case custom(string: String)
}
