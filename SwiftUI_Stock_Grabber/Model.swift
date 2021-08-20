//
//  Model.swift
//  SwiftUI_Stock_Grabber
//
//  Created by Alphonso Sensley II on 8/19/21.
//

import Foundation

extension Double {
    func asCurrency() ->String {
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .currency
        return numberFormater.string(for: self) ?? ""
    }
}
struct Stock:Codable{
    let open: Double
    let high: Double
    let low: Double
    let current: Double
    let previous_close: Double
    let name: String
}
