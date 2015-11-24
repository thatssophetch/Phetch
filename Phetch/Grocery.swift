//
//  Grocery.swift
//  Phetch
//
//  Created by y2bd on 11/24/15.
//  Copyright © 2015 phetch. All rights reserved.
//

import UIKit

class Grocery {
    var name: String
    var count: Int
    
    init(name:String, count:Int) {
        self.name = name
        self.count = count
    }
    
    private static var haves: [Grocery] = Grocery.sampleHaves()
    private static var wants: [Grocery] = Grocery.sampleWants()
    
    static func getHaves() -> [Grocery] {
        return haves
    }
    
    static func getWants() -> [Grocery] {
        return wants
    }
    
    static func addHave(item:Grocery) -> [Grocery] {
        haves.insert(item, atIndex: 0)
        return haves
    }
    
    static func addWant(item:Grocery) -> [Grocery] {
        wants.insert(item, atIndex: 0)
        return wants
    }
    
    static func removeFromHaves(item:Grocery) -> [Grocery] {
        guard let index = haves.indexOf({(groc:Grocery) -> Bool in (groc == item)}) else { return haves }
        
        haves.removeAtIndex(index)
        return haves
    }
    
    static func removeFromWants(item:Grocery) -> [Grocery] {
        guard let index = wants.indexOf({(groc:Grocery) -> Bool in (groc == item)}) else { return wants }
        
        wants.removeAtIndex(index)
        return wants
    }
    
    static func sampleHaves() -> [Grocery] {
        var items = [Grocery]()
        items.append(Grocery(name: "Strawberries", count: 3))
        items.append(Grocery(name: "Garlic", count: 5))
        items.append(Grocery(name: "Milk", count: 1))
        items.append(Grocery(name: "Vanilla Wafers", count: 4))
        items.append(Grocery(name: "Paper Gags", count: 3))
        items.append(Grocery(name: "Brown Sugar", count: 1))
        items.append(Grocery(name: "Laundry Detergent", count: 2))
        items.append(Grocery(name: "Air Freshener", count: 1))
        
        return items
    }
    
    static func sampleWants() -> [Grocery] {
        var items = [Grocery]()
        items.append(Grocery(name: "Soap", count: 3))
        items.append(Grocery(name: "Apples", count: 5))
        items.append(Grocery(name: "Tomatoes", count: 1))
        items.append(Grocery(name: "Paper Towels", count: 4))
        items.append(Grocery(name: "Sponges", count: 3))
        items.append(Grocery(name: "Onions", count: 5))
        items.append(Grocery(name: "Olive Oil", count: 1))
        items.append(Grocery(name: "Bananas", count: 4))
        
        return items
    }
}

func == (left: Grocery, right: Grocery) -> Bool {
    return left.name == right.name
}

func != (left: Grocery, right: Grocery) -> Bool {
    return left.name != right.name
}
