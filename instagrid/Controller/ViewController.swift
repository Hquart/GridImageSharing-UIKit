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
        super.viewDidLoad()
        imagePicker.delegate = self
        //Left layout is selected by default when the app is launched
        changeLayout(layoutButtons[0])
    }
    
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer?) {
        if let gesture = sender {
            if UIDevice.current.orientation.isPortrait && gesture.direction == .up {
                print("I SWIPPPED UP")
                moveMainViewUp()
            
            } else if UIDevice.current.orientation.isLandscape && gesture.direction == .left {
                print("I SWIPPED LEFT")
                moveMainViewLeft()
            }
        }
    }
    
    func moveMainViewUp() {
        UIView.animate(withDuration: 2, animations: {
            self.mainView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
        }, completion: {
            (true) in
            self.shareLayout()
        })
    }
    
    func moveMainViewLeft() {
        UIView.animate(withDuration: 2, animations: {
            self.mainView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        }, completion: {
            (true) in
            self.shareLayout()
        })
        
    }
    
//    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
//        if UIDevice.current.orientation.isPortrait && sender.direction == .up {
//          self.mainView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
//            print("I SWIPPPED UP")
//            shareLayout()
//        } else if UIDevice.current.orientation.isLandscape && sender.direction == .left {
//            mainView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
//            print("I SWIPPED LEFT")
//            shareLayout()
//        }
//    }
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
    // I create an OUtlet of the mainView so I can share it
    @IBOutlet weak var mainView: UIView!
    // I create an Outlet of the Swipe Text Label to init the swipe gesture from it
    @IBOutlet weak var swipeLabel: UILabel!
    
    //Créer 2 methodes une qui move up et l'autre back in
    
    //This Method will make all photo buttons visible:
    func showButtons() {
        for button in photoButtons {
            button.isHidden = false
        }
    }
    func shareLayout() {
        let content = mainView.asImage()
        let activityController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        // We use the completion handler to move back the mainView when the activityController is closed
        activityController.completionWithItemsHandler = {  (activity, success, items, error) in
            UIView.animate(withDuration: 1, animations: {
                self.mainView.transform = .identity
            }, completion: nil)
        }
    }
        
    // This method will implement chosen layout on the mainView
    @IBAction func changeLayout(_ sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "Selected"), for: UIControl.State.normal)
        switch sender {
        case layoutButtons[0]:
            layoutButtons[1].setBackgroundImage(UIImage(named: "unselect2"), for: UIControl.State.normal)
            layoutButtons[2].setBackgroundImage(UIImage(named: "unselect3"), for: UIControl.State.normal)
            showButtons()
            photoButtons[0].isHidden = true
        case layoutButtons[1]:
            layoutButtons[0].setBackgroundImage(UIImage(named: "unselect1"), for: UIControl.State.normal)
            layoutButtons[2].setBackgroundImage(UIImage(named: "unselect3"), for: UIControl.State.normal)
            showButtons()
            photoButtons[2].isHidden = true
        case layoutButtons[2]:
            layoutButtons[0].setBackgroundImage(UIImage(named: "unselect1"), for: UIControl.State.normal)
            layoutButtons[1].setBackgroundImage(UIImage(named: "unselect2"), for: UIControl.State.normal)
            showButtons()
        default: break
        }
    }
    // METHOD FOR THE DELEGATE: when the user picks up an image from the photo library, image is set to the button
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.currentButton?.setImage(pickedImage, for: UIControl.State.normal)
        }
        dismiss(animated: true, completion: nil)
    }
    // METHOD FOR THE DELEGATE: when the user cancels image picking
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
// This UIView extension will permit to convert our MainView to an image file
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}












