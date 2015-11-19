//
//  ImagePostViewController.swift
//  ParseStarterProject
//
//  Created by Mau Pan on 10/10/15.
//  Copyright © 2015 Mau. All rights reserved.
//
//

import UIKit
import Parse

class ImagePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var selectedImage: UIImageView!
    
    @IBOutlet var imageCaption: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func postImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if imageCaption.text != nil && selectedImage.image != nil {
        
            let feeds = PFObject(className: "feeds")
            let imageData = UIImageJPEGRepresentation(selectedImage.image!, 0.75)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
        
            feeds["userid"] = PFUser.currentUser()!.objectId!
        
            feeds["image"] = imageFile
        
            feeds["caption"] = imageCaption.text
            
            feeds.saveInBackgroundWithBlock { (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    var alert = UIAlertController(title: "Post Image Successful", message: "You have successfully posted the image to your feed!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.selectedImage.image = UIImage(named:"placeholder.jpg")
                } else {
                    
                    var alert = UIAlertController(title: "Error Posting Image", message: "There was an error posting the image, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            var alert = UIAlertController(title: "Missing Inputs", message: "You are missing a caption or image input. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }




        
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){

            
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }
    }
    
    @IBAction func chooseFromCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){

            
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.selectedImage.image = image
        })
        
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
