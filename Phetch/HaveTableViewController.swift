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
    private var resetTouch : Bool = false
    
    private var grouped : Bool = false
    
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
        
        // self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        let iv = UIImageView.init(image: UIImage(named: "Phetched Logo.png"))
        iv.frame = CGRectIntegral(iv.frame)
        iv.frame = CGRect(x: iv.frame.origin.x, y: iv.frame.origin.y, width: iv.frame.width, height: 22)
        self.navigationItem.titleView = iv
        iv.contentMode = .ScaleAspectFit
        
        shouldReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Phetched"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if grouped {
            let owners = Grocery.getHaves().map({groc in groc.owner})
            return uniq(owners).count
        }
        else {
            return 1
        }
    }
    
    func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if grouped {
            let owners = uniq(Grocery.getHaves().map({groc in groc.owner})).sort()
            let owner = owners[section]
            
            return Grocery.getHaves().filter({groc in groc.owner == owner}).count
        }
        else {
            return Grocery.getHaves().count
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryTableViewCell", forIndexPath: indexPath)
        
        guard let gtvc = cell as? GroceryTableViewCell else {
            return cell
        }
        
        if gtvc.minusButton.gestureRecognizers == nil || gtvc.minusButton.gestureRecognizers!.count == 0 {
            gtvc.minusButton.addGestureRecognizer(FuncUITapGestureRecognizer.init(target: self, fun: {(tgr) in
                self.decItem(Grocery.getHaves().enumerate().filter({(index : Int, elem : Grocery) -> Bool in elem.name == gtvc.itemName.text!}).first!.index)
            }))
        }
        
        if gtvc.plusButton.gestureRecognizers == nil || gtvc.plusButton.gestureRecognizers!.count == 0 {
            gtvc.plusButton.addGestureRecognizer(FuncUITapGestureRecognizer.init(target: self, fun: {(tgr) in
                self.incItem(Grocery.getHaves().enumerate().filter({(index : Int, elem : Grocery) -> Bool in elem.name == gtvc.itemName.text!}).first!.index)
            }))
        }
        
        if grouped {
            let owners = uniq(Grocery.getHaves().map({groc in groc.owner})).sort()
            let owner = owners[indexPath.section]
            
            let item = Grocery.getHaves().filter({groc in groc.owner == owner})[indexPath.item]
            gtvc.setFrom(item)
        }
        else {
            gtvc.setFrom(Grocery.getHaves()[indexPath.row])
        }
        
        return gtvc
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if grouped {
            
            let owners = uniq(Grocery.getHaves().map({groc in groc.owner})).sort()
            let owner = owners[section]
            
            let view = UIView()
            let label = UILabel()
            
            label.text = owner
            label.textAlignment = .Center
            
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false;
            
            view.addSubview(label);
            
            view.addConstraints(
                [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute:NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)])
            
            return view
        }
        
        return nil
    }
    
    func decItem(row: Int) {
        Grocery.getHaves()[row].count -= 1
        
        var indexPath : NSIndexPath
        if grouped {
            let owners = uniq(Grocery.getHaves().map({groc in groc.owner})).sort()
            let ownerIndex = owners.enumerate()
                                   .filter({(i,v) in v == Grocery.getHaves()[row].owner})[0].index
            
            let itemIndex = Grocery.getHaves().filter({groc in groc.owner == Grocery.getHaves()[row].owner})
                                              .enumerate()
                .filter({(i,v) in v.name == Grocery.getHaves()[row].name})[0].index
            
            indexPath = NSIndexPath(forRow: itemIndex, inSection: ownerIndex)
        }
        else {
            indexPath = NSIndexPath(forItem: row, inSection: 0)
        }
        
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        if Grocery.getHaves()[row].count <= 0 {
            confirmDeleteItem(Grocery.getHaves()[row], indexPath: indexPath)
        }
    }
    
    func incItem(row: Int) {
        Grocery.getHaves()[row].count += 1
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: row, inSection: 0)], withRowAnimation: .Fade)
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
            message: "Do you want to add \"\(grocery.name)\" to the Phetch list?",
            preferredStyle: .ActionSheet)
        
        
        let transferAction = UIAlertAction(title: "Transfer to Phetch", style: .Default, handler: {(aa) -> () in self.transferItem(aa, grocery: grocery, indexPath: indexPath)})
        let removeAction = UIAlertAction(title: "Just Remove", style: .Destructive, handler: {(aa) -> () in self.removeItem(aa, grocery: grocery, indexPath: indexPath)})
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(transferAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func transferItem(alertAction: UIAlertAction!, grocery: Grocery, indexPath: NSIndexPath) {
        
        self.tableView.beginUpdates()
        Grocery.removeFromHaves(grocery)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        if grouped {
            let owners = uniq(Grocery.getHaves().map({groc in groc.owner})).sort()
            let owner = owners[indexPath.section]
            
            let ownerItemCount = Grocery.getHaves().filter({groc in groc.owner == owner}).count
            
            if ownerItemCount <= 1 {
                self.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
        }
        self.tableView.endUpdates()
        
        grocery.count = 1;
        Grocery.addWant(grocery)
        
        resetTouch = true
    }
    
    func removeItem(alertAction: UIAlertAction!, grocery: Grocery, indexPath: NSIndexPath) {
        Grocery.removeFromHaves(grocery)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        if grouped {
            let owners = uniq(Grocery.getHaves().map({groc in groc.owner})).sort()
            let owner = owners[indexPath.section]
            
            let ownerItemCount = Grocery.getHaves().filter({groc in groc.owner == owner}).count
            
            if ownerItemCount <= 1 {
                self.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
        }
        self.tableView.endUpdates()
        
        resetTouch = true
    }
    
    func shouldReload() {
        self.tableView.reloadData()
    }
}

class FuncUITapGestureRecognizer : UITapGestureRecognizer {
    var fun : (UITapGestureRecognizer) -> ()
    
    init(target: AnyObject?, fun:(UITapGestureRecognizer) -> ()) {
        self.fun = fun
        super.init(target: target, action: "")
        
        self.removeTarget(target, action: "")
        self.addTarget(self, action: "invokeTarget:")
    }
    
    func invokeTarget(from: UITapGestureRecognizer!) {
        self.fun(self)
    }
}

