//
//  ViewController.swift
//  myDropDownMenu
//
//  Created by Batuhan Saygili on 1.10.2018.
//  Copyright © 2018 koust. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var demoTextField: UITextField!
    
    
    let VC           = myDropDownController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        VC.yourTextField = demoTextField
        VC.yourList      = ["Array","Deneme","Hey","Apple","Las Vegas","Last","Arr","Rr"]
        VC.yourView      = self.view
        VC.create()
    
        VC.didSelect { (listName, index) in
            self.demoTextField.text = listName
            print(listName)
            print(index)
            self.filterList()
        }
        

    }
    
    
    func filterList(){
        VC.filterList { (filterList) in
            print(filterList)
        }
    }
}

