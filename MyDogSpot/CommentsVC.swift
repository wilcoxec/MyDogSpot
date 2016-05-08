//
//  CommentsVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/7/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentField: MaterialTextField!
    
    var comments = [Comment]()
    
    var userName: String!
    var userImage: String!
    
    var userRef: Firebase!
    
    var userID: String!
    
    var keySent: String!
    var postKey: String!
    var commentsRef: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postKey = keySent
        print("This is the post key: ")
        print(postKey)
        
        commentsRef = DataService.ds.REF_POSTS.childByAppendingPath(postKey).childByAppendingPath("comments")
        
        commentsRef.observeEventType(.Value, withBlock: {
        
            snapshot in
            print(snapshot.value)
            self.comments = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    if let commentDict = snap.value as? Dictionary<String, AnyObject>{
                        
                        print(commentDict)
                        let key = snap.key
                        let comment = Comment(commentKey: key, dictionary: commentDict)
                        self.comments.append(comment)
                    }
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //DataService.ds.REF_POSTS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentCell {
            
            cell.request?.cancel()
            
            //var img: UIImage?
            
            cell.configureCommentCell(comment)
            
            //cell.configureCell(post, img: img)
            
            return cell
        }
        else {
            return CommentCell()
        }
        
    }
    




}
