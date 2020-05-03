//
//  Shop.swift
//  Uber
//
//  Created by Eryk Chrustek on 25/04/2020.
//  Copyright © 2020 Eryk Chrustek. All rights reserved.
//

import Foundation
import RealmSwift

class Shop : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
    
    let orders = List<Order>()

    
}
