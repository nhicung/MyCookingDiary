//
//  TimeViewController.swift
//  MyCookingDiary
//
//  Created by Nhi Cung on 5/8/21.
//  Copyright © 2021 Nhi Cung. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    weak var delegate: TimeViewController?
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveTime))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick time to cook this recipe"
        // Do any additional setup after loading the view.
    }
    
    @objc func saveTime(){
        self.delegate?.dateChanged(date: timePicker.date)
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
