//
//  searchItem.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/9/24.
//
//This is the the basic info that a search item can give you

import Foundation

struct searchItem : Codable, Hashable, Identifiable{
    var id: String
    var name: String
    var servingSize: String
    var calories: String
    var protein: String
    var servingType: String
    
    static let allFoods : [searchItem] = Bundle.main.decode("foods.json")
    
}
