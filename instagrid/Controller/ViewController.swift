//
//  ViewController.swift
//  instagrid
//
//  Created by Naji Achkar on 23/11/2019.
//  Copyright © 2019 Naji Achkar. All rights reserved.
//

import UIKit

// This UIView extension will permit to convert our MainView to an image
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var currentButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    // This method will laucnh the imagePicker when a button is tapped
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        self.currentButton = sender
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    // I create an Outlet collection to identify each photo button
    @IBOutlet var photoButtons: [UIButton]!
    
    // I create an Outlet collection to identify each layout button
    @IBOutlet var layoutButtons: [UIButton]!
    
    //OUTLET of the Main View which will be shared
    @IBOutlet weak var mainView: UIView!
    
    
    
    // I create a function which removes pictures from buttons to have a clean layout when I switch
    func cleanLayout() {
        photoButtons[0].setImage(nil, for: UIControl.State.normal)
        photoButtons[1].setImage(nil, for: UIControl.State.normal)
        photoButtons[2].setImage(nil, for: UIControl.State.normal)
        photoButtons[3].setImage(nil, for: UIControl.State.normal)
    }
    
    @IBAction func leftLayout(_ sender: Any) {
        cleanLayout()
        layoutButtons[0].setBackgroundImage(UIImage(named: "Selected"), for: UIControl.State.normal)
        layoutButtons[1].setBackgroundImage(UIImage(named: "unselect2"), for: UIControl.State.normal)
        layoutButtons[2].setBackgroundImage(UIImage(named: "unselect3"), for: UIControl.State.normal)
        photoButtons[0].isHidden = true
        photoButtons[1].isHidden = false
        photoButtons[1].contentMode = UIView.ContentMode.scaleToFill
        photoButtons[2].isHidden = false
        photoButtons[3].isHidden = false
    }
    
    @IBAction func middleLayout(_ sender: Any) {
        cleanLayout()
        layoutButtons[0].setBackgroundImage(UIImage(named: "unselect1"), for: UIControl.State.normal)
        layoutButtons[1].setBackgroundImage(UIImage(named: "Selected"), for: UIControl.State.normal)
        layoutButtons[2].setBackgroundImage(UIImage(named: "unselect3"), for: UIControl.State.normal)
        photoButtons[0].isHidden = false
        photoButtons[1].isHidden = false
        photoButtons[2].isHidden = true
        photoButtons[3].isHidden = false
        photoButtons[3].contentMode = UIView.ContentMode.scaleToFill
    }
    
    @IBAction func rightLayout(_ sender: Any) {
        cleanLayout()
        layoutButtons[0].setBackgroundImage(UIImage(named: "unselect1"), for: UIControl.State.normal)
        layoutButtons[1].setBackgroundImage(UIImage(named: "unselect2"), for: UIControl.State.normal)
        layoutButtons[2].setBackgroundImage(UIImage(named: "Selected"), for: UIControl.State.normal)
        photoButtons[0].isHidden = false
        photoButtons[1].isHidden = false
        photoButtons[2].isHidden = false
        photoButtons[3].isHidden = false
    }
    
    // METHOD FOR THE DELEGATE: when the user picks up an image from the photo library, image is set to the button
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.currentButton?.setImage(pickedImage, for: UIControl.State.normal)
         }
         dismiss(animated: true, completion: nil)
     }
    
       // METHOD FOR THE DELEGATE: when the user cancels
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             dismiss(animated: true, completion: nil)
    }
    @IBAction func share(_ sender: Any) {
        let content = mainView.asImage()
            let vc = UIActivityViewController(activityItems: [content], applicationActivities: [])
            present(vc, animated: true)
        }
    }


    

    

    
    
    
    
    
    
    
    



