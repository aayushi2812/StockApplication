//
//  Model.swift
//  StockApplication
//
//  Created by user265285 on 11/27/24.
//

import Foundation

struct ResultValues: Codable{
    var count : Int
    var results: [TStock]
}

struct TStock: Codable{
    var name: String
    var performanceId: String
}


struct StockData: Codable {
    let netChange: ValueContainer?
    let name: ValueContainer?
    let lastPrice: ValueContainer?
    let percentNetChange: ValueContainer?
}

struct ValueContainer: Codable {
    let value: Double?
    let stringValue: String?
    
    // Use a custom initializer to handle both numeric and string values
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let doubleValue = try? container.decode(Double.self, forKey: .value) {
            self.value = doubleValue
            self.stringValue = nil
        } else if let stringValue = try? container.decode(String.self, forKey: .value) {
            self.value = nil
            self.stringValue = stringValue
        } else {
            self.value = nil
            self.stringValue = nil
        }
    }
}
typealias StockDictionary = [String: StockData]
