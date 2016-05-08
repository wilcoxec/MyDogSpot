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
    
    
    @IBOutlet weak var commentField: UITextField!
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        self.getUserInfo()
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
    

    @IBAction func addComment(sender: UIButton) {
        
        if let txt = commentField.text where txt != "" {
            
            self.postCommentToFirebase()
        }
    }
    
    func postCommentToFirebase() {
        
        var commentPost: Dictionary<String, AnyObject> = [
            "username": userName,
            "userImageUrl": userImage,
            "userID": userID,
            "commentText": commentField.text!
        ]
        
        let firebaseComment = DataService.ds.REF_POSTS.childByAppendingPath(postKey).childByAppendingPath("comments").childByAutoId()
        firebaseComment.setValue(commentPost)
        
        
        commentField.text = ""
        
        tableView.reloadData()
        
    }

    func getUserInfo() {
        userRef = DataService.ds.REF_USER_CURRENT
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                let user = CreateUser(userKey: key, dictionary: userDict)
                self.unwrapUserInfo(user)
                //self.configureProfile(user)
            }
            
        })
        
    }
    
    func unwrapUserInfo(user: CreateUser) {
        self.userName = user.userName
        self.userImage = user.userImageUrl
        self.userID = user.userKey
    }


}
