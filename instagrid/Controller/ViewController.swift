//
//  ViewController.swift
//  instagrid
//
//  Created by Naji Achkar on 23/11/2019.
//  Copyright © 2019 Naji Achkar. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var currentButton : UIButton?
    
    override func viewDidLoad() {
        // par défaut layout de gauche selectionné
        super.viewDidLoad()
        imagePicker.delegate = self
        // Adding gesture recognizer to the Main View
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.left
        mainView.addGestureRecognizer(swipeUp)
        mainView.addGestureRecognizer(swipeLeft)
    }
    

    
    
    // This method will launch the imagePicker when a button is tapped
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
  
    func moveMainViewUp() {
          
       }
    //CRéer 2 methodes une qui move up et l'autre back in
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isPortrait && gesture.direction == UISwipeGestureRecognizer.Direction.up {
            mainView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            shareLayout()
        } else if UIDevice.current.orientation.isLandscape && gesture.direction == UISwipeGestureRecognizer.Direction.left {
            mainView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            shareLayout()
    }
    }
    
   func shareLayout() {
        let content = mainView.asImage()
        let vc = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
  
    
//    private func transformMainView(gesture: UISwipeGestureRecognizer) {
//        let translation = gesture.translation(in: mainView)
//        mainView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
//    }
    
    // I create a function which removes pictures from buttons to have a clean layout when I switch
    func cleanLayout() {
        for button in photoButtons {
            button.setImage(nil, for: UIControl.State.normal)
        }
    }
        
    //creer une methode generique pour tous les layout avec parametre boutton avec un switch
    
    
    
    
    
    
    
    
    
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
    
    
    
    
    
    

    }


// This UIView extension will permit to convert our MainView to an image
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
    

    
    
    
    
    
    
    
    


