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
    var price: String?
    var owner: String
    
    init(name:String, count:Int, price:String, owner:String) {
        self.name = name
        self.count = count
        self.price = price
        self.owner = owner
    }
    
    init(name:String, count:Int, owner:String) {
        self.name = name
        self.count = count
        self.price = nil
        self.owner = owner
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
        items.append(Grocery(name: "Strawberries", count: 3, price: "3.50", owner: "Annie"))
        items.append(Grocery(name: "Garlic", count: 5, price: "4.50", owner: "Neil"))
        items.append(Grocery(name: "Milk", count: 1, price: "2.50", owner: "Jason"))
        items.append(Grocery(name: "Vanilla Wafers", count: 4, price: "1.50", owner: "Jason"))
        items.append(Grocery(name: "Paper Gags", count: 3, price: "3.50", owner: "Anmol"))
        items.append(Grocery(name: "Brown Sugar", count: 1, price: "3.50", owner: "Ellen"))
        items.append(Grocery(name: "Laundry Detergent", count: 2, price: "3.50", owner: "Annie"))
        items.append(Grocery(name: "Air Freshener", count: 1, price: "3.50", owner: "Neil"))
        
        return items
    }
    
    static func sampleWants() -> [Grocery] {
        var items = [Grocery]()
        items.append(Grocery(name: "Soap", count: 3, owner: "Jason"))
        items.append(Grocery(name: "Apples", count: 5, owner: "Annie"))
        items.append(Grocery(name: "Tomatoes", count: 1, owner: "Annie"))
        items.append(Grocery(name: "Paper Towels", count: 4, owner: "Anmol"))
        items.append(Grocery(name: "Sponges", count: 3, owner: "Anmol"))
        items.append(Grocery(name: "Onions", count: 5, owner: "Neil"))
        items.append(Grocery(name: "Olive Oil", count: 1, owner: "Anmol"))
        items.append(Grocery(name: "Bananas", count: 4, owner: "Neil"))
        
        return items
    }
}

func == (left: Grocery, right: Grocery) -> Bool {
    return left.name == right.name
}

func != (left: Grocery, right: Grocery) -> Bool {
    return left.name != right.name
}
