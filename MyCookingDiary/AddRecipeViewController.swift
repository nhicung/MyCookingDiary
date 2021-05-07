//
//  AddRecipeViewController.swift
//  MyCookingDiary
//
//  Created by Nhi Cung on 4/7/21.
//  Copyright © 2021 Nhi Cung. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentRecipe: Recipe?
    var isChecked = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfStep: UITextField!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var imgRecipePic: UIImageView!
    @IBOutlet weak var btnAddFav: UIButton!
    
    @IBOutlet weak var btnImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if currentRecipe != nil {
            recipeName.text = currentRecipe!.recipeName
            tfTime.text = currentRecipe!.time
            tfStep.text = currentRecipe!.instruction
//            currentRecipe?.add = "Add to Favorite"
            addToFavorite(btnAddFav)
            if currentRecipe!.add != nil {
                btnAddFav.setTitle(currentRecipe!.add, for: .normal)
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentRecipe!.date != nil {
                lblDate.text = formatter.string(from: currentRecipe!.date as! Date)
            }
            if let imageData = currentRecipe?.image as? Data{
                imgRecipePic.image = UIImage(data: imageData)
            }
        }
        changeEditMode(self)
         let textFields: [UITextField] = [recipeName, tfStep,tfTime]
        
        for textField in textFields {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentRecipe == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentRecipe = Recipe(context: context)
        }
        currentRecipe?.recipeName = recipeName.text
        currentRecipe?.time = tfTime.text
        currentRecipe?.instruction = tfStep.text
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(AddRecipeViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddRecipeViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification){
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [recipeName, tfStep,tfTime]
        if sgmtEditMode.selectedSegmentIndex == 0{
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            btnImage.isHidden = true
            btnDate.isHidden = true
            btnAddFav.isHidden = false
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnImage.isHidden = false
            btnDate.isHidden = false
            btnAddFav.isHidden = true
//            btnAddFav.addTarget(self, action: #selector(self.saveRecipe), for: .touchDown)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveRecipe))
        }
    }
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            currentRecipe?.add = "Added!"
            btnAddFav.setTitle(currentRecipe!.add, for: .normal)
            currentRecipe?.favorite = true
        }
    }
    
    
    @objc func saveRecipe() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    func dateChanged(date: Date) {
        if currentRecipe == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentRecipe = Recipe(context: context)
        }
        currentRecipe?.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblDate.text = formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueRecipeDate") {
        let dateController = segue.destination as! DateViewController
        dateController.delegate = self
        }
    }
    
    @IBAction func changePic(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let libraryController = UIImagePickerController()
            libraryController.sourceType = .photoLibrary
//            libraryController.cameraCaptureMode = .photo
            libraryController.delegate = self
            libraryController.allowsEditing = true
//            self.present(libraryController, animated: true, completion: nil)
            self.navigationController?.present(libraryController, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if currentRecipe == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentRecipe = Recipe(context : context)
            }
            currentRecipe?.image = image.jpegData(compressionQuality: 1.0)
            imgRecipePic.contentMode = .scaleAspectFit
            imgRecipePic.image = image
        }
        self.dismiss(animated: true, completion: nil)
//        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        //Or you can get the image url from AssetsLibrary
//        let path = info[UIImagePickerController.InfoKey.referenceURL] as? URL
//        picker.dismiss(animated: true, completion: nil)
    }
    
}
