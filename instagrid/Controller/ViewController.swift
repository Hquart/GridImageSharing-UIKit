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
    var layoutIsEmpty = true // This Boolean will permit to check wether the grid is empty or not before sharing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        //Left layout is selected by default when the app is launched
        changeLayout(layoutButtons[0])
        //I create
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationChanged() {
        if UIDevice.current.orientation.isLandscape {
                    swipeLabel.text = "Swipe Left to share"
                } else {
                    swipeLabel.text = "Swipe Up to share"
                }
            }
    
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer?) {
        if let gesture = sender {
            if UIDevice.current.orientation.isPortrait && gesture.direction == .up {
                moveMainViewUp()
            } else if UIDevice.current.orientation.isLandscape && gesture.direction == .left {
                moveMainViewLeft()
            }
        }
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
    // I create an OUtlet of the mainView so I can share it
    @IBOutlet weak var mainView: UIView!
    // I create an Outlet of the Swipe Text Label to init the swipe gesture from it
    @IBOutlet weak var swipeLabel: UILabel!
    
    //This Method will make all photo buttons visible:
    func showButtons() {
        for button in photoButtons {
            button.isHidden = false
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
    func moveMainViewUp() {
             UIView.animate(withDuration: 2, animations: {
                 self.mainView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
             }, completion: {
                 (true) in
                 self.checkLayout()
             })
         }
         func moveMainViewLeft() {
             UIView.animate(withDuration: 2, animations: {
                 self.mainView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
             }, completion: {
                 (true) in
                 self.checkLayout()
             })
         }
      // This function will present an alert if the user tries to share an empty grid
      func checkLayout() {
          let alert = UIAlertController(title: "Empty Grid", message: "Are you sure you want to share an empty grid ?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
              self.shareLayout() } ))
          alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
              self.mainView.transform = .identity
          }))
          if layoutIsEmpty == true {
              self.present(alert, animated: true)
          } else {
              shareLayout()
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
    // METHOD FOR THE DELEGATE: when the user picks up an image from the photo library, image is set to the button
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.currentButton?.setImage(pickedImage, for: UIControl.State.normal)
            layoutIsEmpty = false
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












