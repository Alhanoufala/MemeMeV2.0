//
//  ViewController.swift
//  MemeMe
//
//  Created by Alhanouf Alawwad on 25/10/1442 AH.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //A dictionary that governs font appearance
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white  ,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:-3.0
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Disable the camera button in cases the device being used doesn't have a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Disable the share button
        shareButton.isEnabled = false
        
        //Subscribe to the keyboard notifications , to allow the view rise when necessary
        subscribeToKeyboardNotifications()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prepare our text fields
        prepareTextField(topTextField ,"TOP" )
        prepareTextField(bottomTextField,"BOTTOM")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unsubscribe from the keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImageBasedOnSourceType(.photoLibrary)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageBasedOnSourceType(.camera)
    }
    
    
    func pickAnImageBasedOnSourceType(_ sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        
        //Enabled the share button
        shareButton.isEnabled = true
        
    }
    
    //Tells the delegate that the user picked an image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        //Cast the value to a UIImage
        if let image = info [.originalImage] as? UIImage{
            imagePickerView.image = image
        }
        //Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
    }
    
    //Tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        //Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
    }
    
    //Text Field
    
    func prepareTextField(_ textField: UITextField, _ text:String){
        //Register delegates
        textField.delegate = self
        
        //Setting the textfield’s initial text
        textField.text = text
        
        //Customize our text fields
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.textAlignment = NSTextAlignment.center
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clearing the default text when the user taps inside the textfield
        if textField.tag == 1 &&  textField.text == "TOP"  {
            topTextField.text = ""
        }
        else if textField.tag == 2 && textField.text == "BOTTOM" {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Dismissed the keyboard when the user presses return
        textField.resignFirstResponder()
        return true
    }
    
    //Keyboared
    
    func subscribeToKeyboardNotifications() {
        //will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //will hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        //Remove all the observers
        NotificationCenter.default.removeObserver(self)
    }
    
    //Shifts the view up when the keyboardWillShow notification comes
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing{
            
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Move the view back down when the keyboard is dismissed
    @objc  func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y  = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in:view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        toolBar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImage
    }
    
    //sharing a meme
    @IBAction func share(){
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(_, completed, _, _) in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
    //Cancel button (Reset)
    @IBAction func cancel(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
        imagePickerView.image = nil
        
        
        
    }
    
}

