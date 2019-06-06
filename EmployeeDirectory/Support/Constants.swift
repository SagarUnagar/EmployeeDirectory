//
//  Constants.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 03/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import Foundation

//MARK:- RESULT BLOCKS
typealias BoolResponseBlock = (_ succeeded: Bool, _ error: Error?) -> Void
typealias ArrayResponseBlock = (_ response: [Any]?, _ error: Error?) -> Void
typealias ResponseBlock = (_ response: Any?, _ error: Error?) -> Void
