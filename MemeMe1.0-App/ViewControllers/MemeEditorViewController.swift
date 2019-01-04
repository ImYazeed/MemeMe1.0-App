//
//  ViewController.swift
//  MemeMe1.0-App
//
//  Created by Yazeed ALZahrani on 12/31/18.
//  Copyright © 2018 Yazeed ALZahrani. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // Outlet
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var importButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // Helpers
    let textField_Delegate = textFieldDelegate()
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarItems()
        configureTextFields(textField: topTextField)
        configureTextFields(textField: bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: ACTIONS
    
    @IBAction func pickAnImageAlbum(_ sender: Any) {
        createImagePickerView(withSourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        createImagePickerView(withSourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewVC.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
       present(activityViewVC, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        originalImage.image = nil
        configureNavigationBarItems()
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    // MARK: imagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage.image = image
            configureNavigationBarItems()
            self.imagePickerControllerDidCancel(picker)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func createImagePickerView(withSourceType sourceType:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Element Configuration
    
    func configureNavigationBarItems() {
        importButton.isEnabled = (originalImage.image != nil)
        cancelButton.isEnabled = (originalImage.image != nil)
    }
    
    func configureTextFields(textField: UITextField){
        textField.delegate = self.textField_Delegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
  
    // MARK: Meme image
    
    func generateMemedImage() -> UIImage {
        
        // Hide NavBar and ToolBar
        self.navigationController?.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // reShow NavBar and ToolBar
        self.navigationController?.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let memedImage:UIImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: originalImage.image!, memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)

    }
    
    // MARK: KEYBOARD MOVMENT
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   @objc func keyboardWillShow(_ notification:Notification) {
    
    if bottomTextField.isEditing && view.frame.origin.y == 0 {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    

}

