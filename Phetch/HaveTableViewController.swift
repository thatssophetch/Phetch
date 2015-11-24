//
//  FirstViewController.swift
//  Phetch
//
//  Created by y2bd on 11/18/15.
//  Copyright (c) 2015 phetch. All rights reserved.
//

import UIKit

class HaveTableViewController: UITableViewController {
    
    private var groceryItemToEdit : Grocery? = nil
    
    @IBAction func unwindFromAdd(sender: UIStoryboardSegue) {
        // shouldReload()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? AddHaveItemViewController,
           let groc = groceryItemToEdit {
            dest.setTo(groc)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Have"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Grocery.getHaves().count
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryTableViewCell", forIndexPath: indexPath)
        
        guard let gtvc = cell as? GroceryTableViewCell else {
            return cell
        }
        
        gtvc.setFrom(Grocery.getHaves()[indexPath.row])
        return gtvc
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        groceryItemToEdit = Grocery.getHaves()[indexPath.row]
        performSegueWithIdentifier("OpenAdd", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            confirmDeleteItem(Grocery.getHaves()[indexPath.row], indexPath: indexPath)
        }
    }
    
    func confirmDeleteItem(grocery: Grocery, indexPath: NSIndexPath) {
        let alert = UIAlertController(
            title: "Removing \(grocery.name)",
            message: "Do you want to add \"\(grocery.name)\" to the Want list?",
            preferredStyle: .ActionSheet)
        
        let transferAction = UIAlertAction(title: "Transfer to Want", style: .Default, handler: {(aa) -> () in self.transferItem(aa, grocery: grocery, indexPath: indexPath)})
        let removeAction = UIAlertAction(title: "Just Remove", style: .Destructive, handler: {(aa) -> () in self.removeItem(aa, grocery: grocery, indexPath: indexPath)})
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(transferAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func transferItem(alertAction: UIAlertAction!, grocery: Grocery, indexPath: NSIndexPath) {
        Grocery.removeFromHaves(grocery)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        grocery.count = 1;
        Grocery.addWant(grocery)
    }
    
    func removeItem(alertAction: UIAlertAction!, grocery: Grocery, indexPath: NSIndexPath) {
        Grocery.removeFromHaves(grocery)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func shouldReload() {
        self.tableView.reloadData()
    }
}

