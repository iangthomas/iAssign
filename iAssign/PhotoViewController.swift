//
//  PhotoViewController.swift
//  iAssign
//
//  Created by Ian Thomas on 10/10/16.
//  Copyright © 2016 KKIT Creations. All rights reserved.
//

import UIKit


protocol PhotoViewControllerDelegate: class {
    func photoViewController(_ controller: PhotoViewController, didAddPhoto photoString: String)
}


class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    
    weak var delegate: PhotoViewControllerDelegate?
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        
        let photoFileName = generatePhotoName()
        
        if let image = photoImageView.image {
            
            if let data = UIImageJPEGRepresentation(image, 0.9) {
                let filename = documentsDirectory().appendingPathComponent(photoFileName)
                try? data.write(to: filename)
                
                // if sucessful... perhas ad something for if the try does not work?
                
                delegate?.photoViewController(self, didAddPhoto: filename.absoluteString)
            }
        }
    }
    
    
    var photoString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        closeButton.isEnabled = true
        
        // if there is no image
        if photoString == "" {
          //  saveButton.isEnabled = false
            title = "Add Photo"

        } else {
           // saveButton.isEnabled = false
            title = "View and Edit Photo"
            
            //load the image
            loadImage()
            
            
            
        }
    }

    func loadImage () {
        
        let fileManager = FileManager.default
        let imagePath = URL(string: photoString)
        
      //  if fileManager.fileExists(atPath: photoString) {
            photoImageView.image = UIImage(contentsOfFile: photoString)
       // }
        
       
        
       // imagePath.appendPathComponent(photoString)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func photoButtonPressed(_ sender: AnyObject) {
        pickPhoto()
    }
    
    func pickPhoto () {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoWithCamera()})
        let chooseFromLibarayAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {_ in self.choosePhotoFromLibrary()})
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibarayAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary () {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            photoImageView.image = image
            saveButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generatePhotoName () -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter.string(from: Date()).appending(".jpeg")
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }


}
