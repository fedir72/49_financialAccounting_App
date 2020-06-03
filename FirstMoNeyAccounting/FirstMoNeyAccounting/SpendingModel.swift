//
//  SpendingModel.swift
//  FirstMoNeyAccounting
//
//  Created by fedir on 01.06.2020.
//  Copyright © 2020 fedir. All rights reserved.
//
import Foundation
import RealmSwift

@objcMembers
class Spending: Object {
    
    dynamic var category: String = ""
    dynamic var cost: Int = 1
    dynamic var date = NSDate()
    
    }

@objcMembers
class Limit: Object {
    dynamic var limitSum = ""
    dynamic var limitDate = NSDate()
    dynamic var limitLastDay = NSDate()
}


