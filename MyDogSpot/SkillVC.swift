//
//  SkillVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/14/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SkillVC: UITableViewController{
    
    //@IBOutlet weak var tableView: UITableView!
    
    var users = [Endorsement]()
    
    var skillKeyReceived: String!
    var dogKeyReceived: String!
    
    var skillKey: String!
    var dogKey: String!
    
    var endorsementRef: Firebase!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillKey = skillKeyReceived
        dogKey = dogKeyReceived
        
        endorsementRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAppendingPath(self.dogKey).childByAppendingPath("skills").childByAppendingPath(self.skillKey).childByAppendingPath("endorsements")
        
        endorsementRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots{
                    if let endorseDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let endorse = Endorsement(endorsementKey: key, dictionary: endorseDict)
                        self.users.append(endorse)
                    }
                }
                
            }
            
            self.tableView.reloadData()
            
        })
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("EndorsementCell") as? EndorsementCell{
            
            cell.request?.cancel()
            
            cell.configureCell(user)
            
            return cell
        }
        else
        {
            return EndorsementCell()
        }

        // Configure the cell...

        //return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
