//
//  ViewController.swift
//  Dank experiments
//
//  Created by Zabe Rauf on 8/7/17.
//  Copyright © 2017 Zaben. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Outlets:
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var topKek: UITextField!
    @IBOutlet weak var bottomKek: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // textField Delegates
    let memeTextAttributes = textDelegate()
    
    struct Meme {
        var topMemeText: String
        var bottomMemeText: String
        var originalImage: UIImage
        var memedImage : UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.topKek.delegate = memeTextAttributes
        self.bottomKek.delegate = memeTextAttributes
        
        //topKek.defaultTextAttributes = memeTextAttributes
        //bottomKek.defaultTextAttributes = memeTextAttributes
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        subscribeToKeyboardNotifications()
        unsubscribeToKeyboardNotificationHide()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        subscribeToKeyboardNotificationHide()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardNotificationHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotificationHide() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomKek.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notfication:Notification) {
        if bottomKek.isFirstResponder {
            view.frame.origin.y = 0 + getKeyboardHeight(notfication)
        }
    }
 
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    
    @IBAction func pickImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topKek.text!.isEmpty {
            topKek.text = "TOP"
        }
        
        if bottomKek.text!.isEmpty {
            bottomKek.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topKek.resignFirstResponder()
        bottomKek.resignFirstResponder()
        self.view.endEditing(true)
        
        return false
    }

    func generateMemedImage() -> UIImage {
        
        // Hide Toolbar/Navbar
        toolbar.isTranslucent = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show Toolbar/Navbar
        toolbar.isTranslucent = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topMemeText: topKek.text!, bottomMemeText: bottomKek.text!, originalImage: imagePicker.image!, memedImage: memedImage)
    }

    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    
}











