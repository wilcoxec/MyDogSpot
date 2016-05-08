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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    
    var user: CreateUser!
    
    
    var UserVC: UsersProfileVC!
    var UserIDtoSend: String!
    
    var CommentVC: CommentsVC!
    var PostKeyToSend: String!
    
    var buttonLabelToSend: String!
    
    
    var userName: String!
    var userImage: String!
    
    var userRef: Firebase!
    
    var userID: String!
    
    var commentsCount: Int!
    
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 400
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
        self.getUserInfo()
        
        
        
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
            
            if let url = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
        }
        else {
            return PostCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 200
        }
        else {
            return tableView.estimatedRowHeight
        }
        
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
                //let urlStr = "https://post.imageshack.us/upload_api.php"
                //let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                
                let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                
                //This came from alamofire github page
                Alamofire.upload(
                    .POST,
                    "https://post.imageshack.us/upload_api.php",
                    multipartFormData: { multipartFormData in
                        multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                        multipartFormData.appendBodyPart(data: keyData, name: "key")
                        multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    },
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON { response in
                                if let info = response.result.value as? Dictionary<String, AnyObject> {
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        if let imgLink = links["image_link"] as? String {
                                            print ("LINK: \(imgLink)")
                                            self.postToFirebase(imgLink)
                                        }
                                    }
                                }
                            }
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                    }
                )
                
                
                
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
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
        
        
    }//end of func postToFirebase
    
    
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
                
               // let vc: UINavigationController = segue.destinationViewController as! UINavigationController
                let comVC = segue.destinationViewController as! CommentsVC
                comVC.keySent = PostKeyToSend
                //let CommentVC = segue.destinationViewController as! CommentsVC
                
                //CommentsVC.
                
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
        
        UserIDtoSend = uCell.userKey
        
      
        //let btn = sender
        //print("the button tag is :")
        print(UserIDtoSend)
        
        //let btnLabel = btn.titleLabel?.text
        //buttonLabelToSend = btn.titleLabel?.text
        //sender.titleLabel?.text = UserIDtoSend
        
        self.performSegueWithIdentifier(SEGUE_GO_TO_USER, sender: sender)
        
        //self.navigationController?.pushViewController(UsersProfileVC, animated: true)
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
   
}















