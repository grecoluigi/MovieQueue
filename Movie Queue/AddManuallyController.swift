//
//  AddManuallyController.swift
//  Movie Queue
//
//  Created by Luigi Greco on 30/08/20.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

class AddManuallyController: UIViewController, UITextFieldDelegate, ImagePickerDelegate {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var selectImageButton: UIButton!
    @IBOutlet var addMovieButton: UIButton!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        addMovieButton.layer.masksToBounds = true
        addMovieButton.layer.cornerRadius = 12.0
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        selectImageButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    @IBAction func choosePoster(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func addMovie(_ sender: Any) {
        if let title = titleTextField.text, let year = Int(yearTextField.text!), let  poster = selectImageButton.image(for: .normal) {
            MovieStore.movieStore.addMovie(title: title, year: year, poster: poster)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
            }
        } else if let title = titleTextField.text, let year = Int(yearTextField.text!){
            MovieStore.movieStore.addMovie(title: title, year: year)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Missing info", message: "You need to fill both title and year to add a movie.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func didSelect(image: UIImage?) {
        self.selectImageButton.setImage(image, for: .normal)
    }
    
}

