//
//  ContentView.swift
//  SwiftUI_Stock_Grabber
//
//  Created by Alphonso Sensley II on 8/18/21.
//

import SwiftUI


struct ContentView: View {
    @State private var stockSymbol:String = ""
    @State private var stockObject:Stock?
    @State private var isFetchingData = false
    @State private var errorOccured = false
    @State private var timeStamp = ""
    @State private var isFavorite = false
    @State private var favorites:[Stock] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                if isFetchingData {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: 100, height: 100, alignment: .center)
                }
                VStack(alignment:.center,spacing: 20) {
                    VStack {
                        if let stockObject = stockObject {
                            Text("Company: \(stockObject.name)")
                                .font(.largeTitle)
                                .padding(.bottom, 15)
                            VStack(alignment:.leading) {
                                Text("As Of \(timeStamp)")
                                Text("Opening Price: \(stockObject.open.asCurrency())")
                                Text("High Price: \(stockObject.high.asCurrency())")
                                Text("Low Price: \(stockObject.low.asCurrency())")
                                Text("Current Price: \(stockObject.current.asCurrency())")
                                HStack {
                                Image(systemName:stockObject.current.asCurrency() > stockObject.open.asCurrency() ? "arrow.up.square.fill" : "arrow.down.app.fill")
                                    Text(stockObject.current.asCurrency() > stockObject.open.asCurrency() ? "UP \((stockObject.current - stockObject.open).asCurrency())" : "DOWN \((stockObject.open - stockObject.current).asCurrency())")
                                        .background(stockObject.current.asCurrency() > stockObject.open.asCurrency() ? Color.green : Color.red)
                                }
                                HStack {
                                    Image(systemName: isFavorite ? "star.fill" : "star")
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .onTapGesture {
                                            isFavorite.toggle()
                                            favorites.append(stockObject)
                                        }
                                        .background(isFavorite ? Color.red : Color.gray)
                                    Text(isFavorite ? "Favorited!" :"Tap To Favorite")
                                }
                            }
                        }
                    }
                    TextField("Enter Stock Symbol", text:$stockSymbol)
                        .frame(width: 200, height: 25, alignment: .center)
                        .disableAutocorrection(true)
                    
                    if #available(iOS 15.0, *) {
                        Button("Get Stock") {
                            isFavorite = false
                            isFetchingData = true
                            errorOccured = false
                            Service.getStockForSymbol(symbol: stockSymbol) { stock, error in
                                print("Call Finished!!")
                                if error != nil {
                                    errorOccured = true
                                    timeStamp = ""
                                }
                                self.stockObject = stock
                                timeStamp = getDate()
                                isFetchingData = false
                                self.stockSymbol = ""
                                print("Favorites Array:.... \(favorites)")
                            }
                        }
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 45, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .alert("Could Not Find Stock", isPresented: $errorOccured) {
                            Button("OK", role: .cancel) { }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    Spacer()
                    
                }.navigationTitle("Stock Picker")
            }
        }
    }
    
    func getDate()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
