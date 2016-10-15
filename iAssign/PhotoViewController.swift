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
        
    @IBOutlet weak var addPhotoButton: UIButton!
    
    weak var delegate: PhotoViewControllerDelegate?
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        
        let photoFileName = generatePhotoName()
        
        if let image = photoImageView.image {
            
            if let data = UIImageJPEGRepresentation(image, 0.9) {
            let filename = documentsDirectory().appendingPathComponent(photoFileName)

                do {
                    try data.write(to: filename)
                    delegate?.photoViewController(self, didAddPhoto: photoFileName)
                } catch {
                    print ("error saving photo")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closedButtonPressed(_ sender: AnyObject) {
         dismiss(animated: true, completion: nil)
    }
    
    var photoString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        closeButton.isEnabled = true
        
        // if there is no image
        if photoString == "" {
            title = "Add Photo"
            addPhotoButton.setTitle("Add Photo", for: .normal)
            closeButton.title = "Cancel"

        } else {
           // saveButton.isEnabled = false
            title = "View or Change Photo"
            addPhotoButton.setTitle("Change Photo", for: .normal)
            closeButton.title = "Back"
            //load the image
            loadImage()
        }
    }

    func loadImage () {
        let path = documentsDirectory().appendingPathComponent(photoString)
        if let data = try? Data (contentsOf: path) {
            let testImage = UIImage (data: data, scale: 1.0)
            photoImageView.image = testImage
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
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
            addPhotoButton.setTitle("Change Photo", for: .normal)
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
    
   }
