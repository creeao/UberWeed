//
//  OrderToggleAlert.swift
//  Uber
//
//  Created by Eryk Chrustek on 07/05/2020.
//  Copyright © 2020 Eryk Chrustek. All rights reserved.
//
//
//import SwiftUI
//import Combine
//import RealmSwift
//import MapKit
//
//struct OrderToggleAlert : View {
//    
//     let realm = try! Realm()
//     var orders = [Order]()
//    
//    @State var map = MKMapView()
//    
//    var body: some View {
//        
//        VStack {
//        
//        ZStack(alignment: .topTrailing) {
//            
//            VStack(spacing: 20) {
//                
//                HStack {
//                    
//                    VStack(alignment: .leading, spacing: 5) {
//                        
//                        Text(self.name)
//                            .font(.title)
//                            .fontWeight(.semibold)
//                            .padding(.bottom, 5)
//                        
//                        HStack {
//                            
//                            Text("How much?")
//                            
//                            Button(action: {
//                                
//                                if self.quantityOfGrams == 1 {
//                                    
//                                    self.quantityOfGrams = 1
//                                    
//                                } else {
//                                    self.quantityOfGrams -= 1
//                                }
//                                
//                            }) {
//                                
//                                Image(systemName: "minus")
//                                    .resizable()
//                                    .frame(width: 15, height: 2)
//                                    .padding(.vertical, 2)
//                                    .foregroundColor(Color("FontColor"))
//                            }
//                            
//                            Text("\(self.quantityOfGrams)")
//                                .fontWeight(.bold)
//                            
//                            Button(action: {
//                                
//                                self.quantityOfGrams += 1
//                                
//                            }) {
//                                
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
//                                    .padding(.horizontal, 2)
//                                    .foregroundColor(Color("FontColor"))
//                            }
//                        }
//                        
//                        HStack {
//                            
//                            Text("Expected time")
//                            Text(self.time)
//                                .fontWeight(.bold)
//                        }
//                        
//                        HStack {
//                            
//                            Text("Cost of delivery")
//                            Text(self.distance + "$")
//                                .fontWeight(.bold)
//                            
//                        }
//                    }
//                    .padding(10)
//                    
//                    Spacer()
//                }
//                
//                Button(action: {
//                    
//                    self.showingAlert = true
//                    
//                    if let currentShop = self.parentOrder {
//                        do {
//                            try self.realm.write {
//                                let newOrder = Order()
//                                newOrder.code = "Oki, rly"
//                                
//                                newOrder.quantity = self.quantityOfGrams
//                                
//                                newOrder.cost = Double(self.distance)! + (Double(self.quantityOfGrams) * 10.00)
//                                newOrder.userAddress = self.userAddress
//                                currentShop.orders.append(newOrder)
//                            }
//                        } catch {
//                            print("Error saving new orders, \(error)")
//                        }
//                    }
//                    
//                    self.loading.toggle()
//                    
//                }) {
//                    
//                    Image("ButtonImage")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 30)
//                        
//                        .padding(.vertical, 10)
//                        .frame(width: UIScreen.main.bounds.width / 1.6)
//                }
//                .background(Color("ButtonColor"))
//                .cornerRadius(10)
//                
//            }
//            
//            Button(action: {
//                
//                self.map.removeOverlays(self.map.overlays)
//                self.map.removeAnnotations(self.map.annotations)
//                self.destination = nil
//                
//                self.show.toggle()
//                
//                self.viewDataShop()
//                
//                
//            }) {
//                Image(systemName: "xmark")
//                    .foregroundColor(Color("FontColor"))
//                    .padding(15)
//            }
//        }
//        .padding(.vertical)
//        .padding(.horizontal)
//        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//            
//        .background(Color("BackgroundColor"))
//        .cornerRadius(15)
//        .frame(width: UIScreen.main.bounds.width / 1.05)
//        .shadow(radius: 20)
//    }
//}
//}
