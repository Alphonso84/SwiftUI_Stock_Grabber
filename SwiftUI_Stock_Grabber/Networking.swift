//
//  Networking.swift
//  SwiftUI_Stock_Grabber
//
//  Created by Alphonso Sensley II on 8/19/21.
//

import Foundation
import UIKit

class Service {
    
    static func getStockForSymbol(symbol:String, completion: @escaping (Stock?, Error?) -> ()) {
        let myurlString = "https://api.lil.software/stocks?symbol=\(symbol.uppercased())"
        print(myurlString)
        guard let myUrl = URL(string:myurlString) else {return}
        let request = URLRequest(url: myUrl)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Starting Call.......")
            
            guard let unwrappedData = data else {return}
            do {
                let stock = try JSONDecoder().decode(Stock.self, from: unwrappedData) 
                completion(stock,nil)
                print(stock)
            } catch {
                completion(nil,error)
                print(error)
            }
        } .resume()
    }
}
