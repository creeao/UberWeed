//
//  Order.swift
//  Uber
//
//  Created by Eryk Chrustek on 25/04/2020.
//  Copyright © 2020 Eryk Chrustek. All rights reserved.
//

import Foundation
import RealmSwift

class Order : Object {
    @objc dynamic var code : String = ""
    @objc dynamic var quantity : Int = 0
    @objc dynamic var cost : Double = 0.0
    @objc dynamic var userAddress : String = ""
    
    @objc dynamic var shop: Shop?
}
