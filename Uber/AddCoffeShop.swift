//
//  AddCoffeShop.swift
//  Uber
//
//  Created by Eryk Chrustek on 07/05/2020.
//  Copyright © 2020 Eryk Chrustek. All rights reserved.
//

import SwiftUI
import RealmSwift
import Combine

struct AddCoffeShop : View {
    
    let realm = try! Realm()
    var shops = [Shop]()

    @State private var showingAlert = false
    
    var body: some View {
        
        Button(action: {
            
            self.showingAlert = true
            
            let newShopy = Shop()
            newShopy.name = "Medicine, rly"
            
            //Enter coordinates close to your location in the simulator or psyhical device
            newShopy.latitude = 40.7152903465603
            newShopy.longitude = -74.0123063317316

            self.addCoffeShop(shop: newShopy)

        }) {
            Image(systemName: "plus")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(Color("FontColor"))
            
        }
    }
    
    func addCoffeShop(shop: Shop) {
        do {
            try realm.write {
                realm.add(shop)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
}

