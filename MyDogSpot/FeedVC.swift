//
//  FeedVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/26/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//
import UIKit
import Firebase
import Alamofire
import SDWebImage

import AWSS3
import AWSCore
import AWSDynamoDB
import AWSSQS
import AWSSNS
import AWSCognito

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    
    var user: User!
    
    
    var UserVC: UsersProfileVC!
    var UserIDtoSend: String!
    
    var CommentVC: CommentsVC!
    var PostKeyToSend: String!
    
    var buttonLabelToSend: String!
    
    
    var userName: String!
    var userImage: String!
    
    //var userRef: Firebase!
    
    var userID: String!
    
    var commentsCount: Int!
    
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

        tableView.delegate = self
        tableView.dataSource = self
                
        
        REF_POSTS.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            print(snapshot.value)
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                        self.setPostUserInfo(post)
                        
                    }
                    
                }
                
                
            }
        
            self.tableView.reloadData()
        })

        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return posts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
        
            cell.request?.cancel()
        
            var img: UIImage?
        
            if let url = post.postImage {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
        
            cell.configureCell(post, img: img)
        
            return cell
        }
        else {
            return PostCell()
        }
        //return tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let post = posts[indexPath.row]
//        
//        if post.imageUrl == nil {
//            return 200
//        }
//        else {
//            return tableView.estimatedRowHeight
//        }
//        
//    }

    
    func setPostUserInfo(post: Post) {
        
        REF_USERS.child(post.postUserKey).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            print(snapshot.value)
            
            if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                let user = User(userKey: key, dictionary: userDict)
                post.setUserInfo(user)
            }
            
        })
    }
    
    func unwrapUserInfo(user: User) {
        
        self.userName = user.userName
        self.userImage = user.userImageUrl
        self.userID = user.userKey
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        print("identifier")
        print(segue.identifier)
        
        print("sender")
        print(sender)
        
        
        
        if(segue.identifier == SEGUE_GO_TO_USER){
        
            if(sender is UIButton!){
                let UserVC = segue.destinationViewController as! UsersProfileVC
                let btninfo = sender as! UIButton
                btninfo.titleLabel?.text = UserIDtoSend
                
                print(btninfo.titleLabel?.text)
                
                UserVC.toPass = UserIDtoSend
                
            }
        
        }
        
        if (segue.identifier == SEGUE_COMMENTS_SECTION){
            if(sender is UIButton!){
                let comVC = segue.destinationViewController as! CommentsVC
                comVC.keySent = PostKeyToSend
                
            }
        }
                
    }
    
    
   // func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     //   NSLog("You selected cell number: \(indexPath.row)!")
        //self.performSegueWithIdentifier("yourIdentifier", sender: self)
    //}
    
    
    
    @IBAction func performProfileView(sender: UIButton!) {
        
        var uCell: Post!
        var rowNum: Int!
        
        let point = tableView.convertPoint(CGPointZero, fromView: sender)
        if let indexPath = tableView.indexPathForRowAtPoint(point) {
            NSLog("You selected cell number: \(indexPath.row)!")
            rowNum = indexPath.row
            
        }
        
        uCell = posts[rowNum]
        
        print("this is the cell:")
        print(uCell)
        
        //UserIDtoSend = uCell.userKey
        
        print(UserIDtoSend)

        
        self.performSegueWithIdentifier(SEGUE_GO_TO_USER, sender: sender)
        
    }

    @IBAction func goToComments(sender: UIButton) {
        
        var uCell: Post!
        var rowNum: Int!
        
        let point = tableView.convertPoint(CGPointZero, fromView: sender)
        
        if let indexPath = tableView.indexPathForRowAtPoint(point) {
            NSLog("You selected cell number: \(indexPath.row)!")
            rowNum = indexPath.row
            
        }
        
        uCell = posts[rowNum]
        
        print("this is the cell:")
        print(uCell)
        
        PostKeyToSend = uCell.postKey
        
        print("Post key to send:")
        print(PostKeyToSend)
        
        
        self.performSegueWithIdentifier(SEGUE_COMMENTS_SECTION, sender: sender)
        
    }
    
    
    
    
    
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
    
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }// end of @IBAction func selectImage
    
    
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postField.text where txt != "" {
            
            if let img = imageSelectorImage.image where imageSelected == true {
                
                var path: NSString!
                path = NSTemporaryDirectory().stringByAppendingString("image.png")
                
                var imageData: NSData!
                imageData = UIImagePNGRepresentation(img)
                
                imageData.writeToFile(path as String, atomically: true)
                
                var url: NSURL!
                url = NSURL(fileURLWithPath: path as String)
                
                let uploadRequest = AWSS3TransferManagerUploadRequest()
                
                uploadRequest.bucket = S3BucketName
                uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + "." + "png"
                uploadRequest.contentType = "image/png"
                uploadRequest.body = url
                
                let transferManager = AWSS3TransferManager.defaultS3TransferManager()
                
                transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                    if let error = task.error {
                        print("Upload failed ❌ (\(error))")
                    }
                    if let exception = task.exception {
                        print("Upload failed ❌ (\(exception))")
                    }
                    if task.result != nil {
                        let s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
                        print("Uploaded to:\n\(s3URL)")
                        self.postToFirebase(uploadRequest.key)
                        //self.postUserToFirebase(uploadRequest.key)
                    }
                    else {
                        print("Unexpected empty result.")
                    }
                    
                    return nil
                }
                
                
            }
            else {
                self.postToFirebase(nil)
            }
            
            
        }
        
    }//end of @IBAction makePost
    
    func postToFirebase(imgUrl: String?) {
        
        var post: Dictionary<String, AnyObject> = [
            "username": userName,
            "userImageUrl": userImage,
            "description": postField.text!,
            "likes": 0,
            "userID": userID
        ]
        
        //Check if an image exists in the post
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        //Create new id for post object and set value of object
        //let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        //firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
        
        
    }//end of func postToFirebase
   
}















