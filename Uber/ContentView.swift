//
//  ContentView.swift
//  Uber
//
//  Created by Eryk Chrustek on 24/04/2020.
//  Copyright © 2020 Eryk Chrustek. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import RealmSwift
import Combine

struct ContentView: View {
    
    var body: some View {
        
        Home()
    }
}

struct Home : View {
    
    let realm = try! Realm()
    var shops = [Shop]()
    var orders = [Order]()
    
    //var shops = Results<Shop>?.self
    
    func addCoffeShop(shop: Shop) {
        do {
            try realm.write {
                realm.add(shop)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func addOrder(order: Order) {
        do {
            try realm.write {
                realm.add(order)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func viewDataShop() {
        
        let shopObjects = realm.objects(Shop.self)
        
        for shop in shopObjects
            {
                let newPoint = MKPointAnnotation()
                newPoint.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
                newPoint.title = shop.name
                map.addAnnotation(newPoint)

            }
    }
   
    
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    @State var name = ""
    @State var distance = ""
    @State var time = ""
    @State var show = false
    
    @State var userAddress = ""

    @State var loading = false
    @State var book = false
    @State var doc = ""
    
    @State var quantityOfGrams : Int = 1
    
    @State var parentOrder : Shop? {
        didSet {
            viewDataShop()
        }
    }
    
    
    @State private var showingAlert = false

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    HStack {
//                        Button(action: {
//                            self.showingAlert = true
//
//                            let newShopy = Shop()
//                            newShopy.name = "Medicine, rly"
//                            newShopy.latitude = 40.7152903465603
//                            newShopy.longitude = -74.0123063317316
//
//                            self.addCoffeShop(shop: newShopy)
//
//                        }) {
//                            Image(systemName: "plus")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(Color("FontColor"))
//                        }
//
                        Image("Logo")
                        .resizable()
                        .scaledToFit()
                        
//                        Button(action: {ĺ
//                            self.showingAlert = true
//
//                            let newShopy = Shop()
//                            newShopy.name = "Medicine, rly"
//                            newShopy.latitude = 40.7152903465603
//                            newShopy.longitude = -74.0123063317316
//
//                            self.addCoffeShop(shop: newShopy)
//
//                        }) {
//                            Image(systemName: "text.alignright")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(Color("FontColor"))
//                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .background(Color("BackgroundColor"))
                .shadow(radius: 20)
                .zIndex(1)

                MapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, name: self.$name, distance: self.$distance, time: self.$time, show: self.$show, parentOrder: self.$parentOrder, userAddress: self.$userAddress)
                    .onAppear {
                        self.manager.requestAlwaysAuthorization()
                }
                .zIndex(0)
            }
            
            if self.destination != nil && self.show {
                
                ZStack(alignment: .topTrailing) {
                    
                    VStack(spacing: 20) {
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 5) {

                            Text(self.name)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.bottom, 5)
                            
                            HStack {
                                
                                
                                
                                Text("How much?")
                                
                                Button(action: {
                                    
                                    if self.quantityOfGrams == 1 {
                                    
                                    self.quantityOfGrams = 1
                                        
                                    } else {
                                        self.quantityOfGrams -= 1
                                    }
                                    
                                }) {
                                    
                                    Image(systemName: "minus")
                                    .resizable()
                                    .frame(width: 15, height: 2)
                                    .padding(.vertical, 2)
                                    .foregroundColor(Color("FontColor"))
                                }

                                Text("\(self.quantityOfGrams)")
                                    .fontWeight(.bold)
                                
                                Button(action: {
                                    
                                    self.quantityOfGrams += 1
                                    
                                }) {
                                    
                                    Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.horizontal, 2)
                                    .foregroundColor(Color("FontColor"))
                                }
                            }
                            
                            HStack {
                                
                                Text("Expected time")
                                Text(self.time)
                                    .fontWeight(.bold)
                            }
                            
                            HStack {
                                
                                Text("Cost of delivery")
                                Text(self.distance + "$")
                                    .fontWeight(.bold)
                                
                            }
                        }
                        .padding(10)
                        
                        Spacer()
                    }
                        
                    Button(action: {
                        
                        self.showingAlert = true
                        
                        if let currentShop = self.parentOrder {
                            do {
                                try self.realm.write {
                                    let newOrder = Order()
                                    newOrder.code = "Oki, rly"

                                    newOrder.quantity = self.quantityOfGrams
                                    
                                    newOrder.cost = Double(self.distance)! + (Double(self.quantityOfGrams) * 10.00)
                                    newOrder.userAddress = self.userAddress
                                    currentShop.orders.append(newOrder)
                                }
                            } catch {
                                print("Error saving new orders, \(error)")
                            }
                        }

                         self.loading.toggle()
                        
                    }) {
                        
                        Image("ButtonImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                            
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 1.6)
                    }
                    .background(Color("ButtonColor"))
                    .cornerRadius(10)

                }
                    
                    Button(action: {
                        
                        self.map.removeOverlays(self.map.overlays)
                        self.map.removeAnnotations(self.map.annotations)
                        self.destination = nil

                        self.show.toggle()
                        
                        self.viewDataShop()
                        
                        
                    }) {
                        Image(systemName: "xmark")
                        .foregroundColor(Color("FontColor"))
                        .padding(15)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                
                .background(Color("BackgroundColor"))
                .cornerRadius(15)
                .frame(width: UIScreen.main.bounds.width / 1.05)
                .shadow(radius: 20)
                }
            
        }
            
           if self.loading{
                
            Booked(doc: self.$doc, loading: self.$loading, book: self.$book, time: self.$time, distance: self.$distance, quantityOfGrams: self.$quantityOfGrams)
            }
            
           
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: self.$alert) { () -> Alert in
            Alert(title: Text("Error"), message: Text("Please enable location in setting"), dismissButton: .destructive(Text("Ok")))
        }
    }
}


struct Loader : View {
    
    @State var show = false
    
    var body: some View {
        
        GeometryReader {_ in
            
            VStack(spacing: 20) {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: self.show ? 360 : 0))
                    .onAppear {
                        withAnimation(Animation.default.speed(0.45).repeatForever(autoreverses: false)) {
                            
                            self.show.toggle()
                        }
                }
                
                Text("Please Wait...")
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 40)
            .background(Color.white)
            .cornerRadius(12)
            
        }
        .background(Color.black.opacity(0.25).edgesIgnoringSafeArea(.all))
        
    }
}

struct MapView : UIViewRepresentable {
    
    let realm = try! Realm()
    
    var shops: Results<Shop>!
    
    

    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    
    func viewDataShop() {
        
        let shopObjects = realm.objects(Shop.self)
        
        for shop in shopObjects
            {
                let newPoint = MKPointAnnotation()
                newPoint.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
                newPoint.title = shop.name
                map.addAnnotation(newPoint)

            }
    }
    
    @Binding var map : MKMapView
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    @Binding var name : String
    @Binding var distance : String
    @Binding var time : String
    @Binding var show : Bool
    @Binding var parentOrder : Shop?
    
    @Binding var userAddress : String
    
    
    func makeUIView(context: Context) -> MKMapView {
        
        // Pins on map
        self.viewDataShop()

        map.delegate = context.coordinator
        manager.delegate = context.coordinator
        map.showsUserLocation = true
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator : NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        
        
        let realm = try! Realm()
        var shops: Results<Shop>!
        //var shops = [Shop]()
        
        var orders = [Order]()
        
        var parent : MapView
        var selectedAnnotation: MKPointAnnotation?
        
        init(parent1: MapView) {
            parent = parent1
            
        }

        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .denied {
                self.parent.alert.toggle()
            }
            else {
                self.parent.manager.startUpdatingLocation()
                
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let region = MKCoordinateRegion(center: locations.last!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            self.parent.source = locations.last!.coordinate
            print(self.parent.source!)
            
            self.parent.map.region = region
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
             self.selectedAnnotation = view.annotation as? MKPointAnnotation

            
            self.parent.name = view.annotation?.title! ?? "No name"
            let z = realm.objects(Shop.self).filter(("name CONTAINS[cd] %@"), self.parent.name)
            self.parent.parentOrder = z[0]
            
            
            self.parent.destination = (selectedAnnotation?.coordinate)!

            let decoder = CLGeocoder()
            decoder.reverseGeocodeLocation(CLLocation(latitude: self.parent.source.latitude, longitude: self.parent.source.longitude)) { (places, err) in
                
                if err != nil {

                    print((err?.localizedDescription)!)
                    return
                }
                
                self.parent.show = true
                self.parent.userAddress = String("\((places?.first?.areasOfInterest)!)")
                

            }

             let req = MKDirections.Request()
             req.source = MKMapItem(placemark: MKPlacemark(coordinate: self.parent.source))
             req.destination = MKMapItem(placemark: MKPlacemark(coordinate: (selectedAnnotation?.coordinate)!))
             
             let directions = MKDirections(request: req)
             directions.calculate { (dir, err) in
                 
                 if err != nil {
                     
                     print((err?.localizedDescription)!)
                     return
                 }
                 
                 let polyline = dir?.routes[0].polyline
                 
                 let dis = Double((dir?.routes[0].distance)!)
                 self.parent.distance = String(format: "%.2f", dis / 1000)
                 
                 let time = Double((dir?.routes[0].expectedTravelTime)!)
                 self.parent.time = String(format: "%.0f", time / 60)

                 self.parent.map.removeOverlays(self.parent.map.overlays)
                 self.parent.map.addOverlay(polyline!)
                 self.parent.map.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
                 
             }
        
        }
        
        //Custom track line
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                let over = MKPolylineRenderer(overlay: overlay)
                over.strokeColor = .systemGreen
                over.lineWidth = 6
                return over
            }
               
        //Custom Pin
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                if !(annotation is MKPointAnnotation) {
                    return nil
                }
            
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationIdentifier")
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationIdentifier")
                    annotationView!.canShowCallout = true
                   
                }
                else {
                    
                    annotationView!.annotation = annotation
                    
                }
                let pinImage = UIImage(named: "Pin")
                annotationView!.image = pinImage
                return annotationView
            }
    }
}

struct Booked : View {

    @Binding var doc : String
    @Binding var loading : Bool
    @Binding var book : Bool
    @Binding var time : String
    @Binding var distance : String
    @Binding var quantityOfGrams : Int
    
    
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack(spacing: 10){
                
                Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(Color("Green"))
                
                HStack {

                    Text("Your order should be in")
                    Text("\(self.time) mins")
                        .fontWeight(.bold)
                }
                .padding(.top, 10)
                
                HStack {

                    Text("You pay")
                    Text("\(String(format: "%.2f", (Double(self.distance)! + (Double(self.quantityOfGrams) * 10.00)))) $")
                        .fontWeight(.bold)
                }
                .padding(.bottom, 10)


                Button(action: {
 
                    self.loading.toggle()

                }) {
                    
                    Text("Done")
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    
                }
                .background(Color("Green"))
                .cornerRadius(12)
            }
            .padding()
            .background(Color("BackgroundColor"))
            .cornerRadius(17)
            .shadow(radius: 20)
        }
        .background(Color.gray.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
