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
    @IBOutlet weak var didSelectName: UILabel!
    
    
    let VC           = myDropDownController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
            VC.yourTextField = demoTextField
            VC.yourList      = ["Trail Version","Hey","Apple0","Apple1","Las Vegas","Last","Arr","Rr"]
            VC.yourView      = self.view
            VC.alwaysOpen    = false
            VC.cornerRadius  = 5
            VC.create(position: .top,positonAuto: true)
        
    
        VC.didSelect { (listName, index) in
            self.demoTextField.text = listName
            print(listName)
            print(index)
            self.didSelectName.text = listName + " - Index: \(index)"
            self.filterList()
        }
        
        VC.willOpen {
            print("will Show")
        }
        
        
        VC.didLoad {
            print("did Load")
        }
        
        VC.didClose {
            print("did Close")
        }

    }
    
    
    func filterList(){
        VC.filterList { (filterList) in
            print(filterList)
        }
    }
    
    @IBAction func showAction(_ sender: Any) {
        VC.show()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        VC.close()
    }
    
}

