//
//  ViewController.swift
//  Camera App
//
//  Created by Sai Prasad Chittari on 8/25/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var capturedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickTheCamera(_ sender: Any) {
        checkCameraPermissions()
    }
    func checkCameraPermissions() {
        let cameraAuthorisationStatus = AVCaptureDevice.authorizationStatus(for: .video) 
        
        switch cameraAuthorisationStatus {
        case .authorized:
            //Open my camera
            openCamera()
        case .notDetermined :
            //open settins app
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("camers acess is given")
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert()
                    }
                    print("Camera acess denied")
                }
            }
        case .denied, .restricted :
            //Open settings app
            DispatchQueue.main.async {
                self.showSettingsAlert()
            }
        
        default :
            break
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
//            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
        else {
            //Show photo library
            self.showPhotoLibrary()
            
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(title: "Camera acess denied", message: "Please enable camera acecess in settins to use camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showPhotoLibrary()
        })
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.capturedImageView.image = capturedImage
            }
//            DispatchQueue.main.async {
//                UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil)
//            }
        }
        DispatchQueue.main.async {
            
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}


