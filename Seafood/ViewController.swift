//
//  ViewController.swift
//  Seafood
//
//  Created by HAI DANG on 11/25/17.
//  Copyright © 2017 HAI DANG. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
    
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
        
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else{
                
                fatalError("Could not convert into UIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image:CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed!")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else{
                
                fatalError("Model failed to process image")
            }
            
            //print(results)
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red]
            
            if let firstResult = results.first{
                
                if firstResult.identifier.lowercased().contains("hotdog"){
                    
                    print(firstResult.identifier)
                    
                    print(firstResult.confidence)
                    
                    self.navigationItem.title = "Hotdog!"
                    
                }else{
                    
                    //print(firstResult.identifier)
                    
                    print(firstResult.identifier)
                    
                    print(firstResult.confidence)
                    
                    self.navigationItem.title = "Probally \(firstResult.identifier)"
                }
            }
            
        }
            
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
            
        }catch{
            
            print(error)
            
        }
    }

    @IBAction func camerTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    

}

