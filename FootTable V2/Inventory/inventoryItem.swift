//
//  inventoryItem.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/11/24.
//

import Foundation

class inventoryItem : Identifiable, ObservableObject, Codable {
    
    var id : UUID
    var name : String
    var stock : String
    
    

    init(id: UUID = UUID(), name: String, stock: String) {
            self.id = id
            self.name = name
            self.stock = stock
    }
    static let example = inventoryItem(name: "Nutella", stock: "Low")

    
    
    
}
