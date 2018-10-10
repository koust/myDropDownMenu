//
//  myDropDownController.swift
//  myDropDownMenu
//
//  Created by Batuhan Saygili on 1.10.2018.
//  Copyright © 2018 koust. All rights reserved.
//

import UIKit

protocol myDropDownControllerDelegate {
    func reloadData()
}
//
public enum position {
    case top
    case bottom
}

public class myDropDownController: UIViewController {

    
    private var myView : UIView                   = UIView()
    
    //  We create table view and reload data
    fileprivate var myTableView : UITableView! {
        didSet {
            self.myTableView.reloadData()
        }
    }
    
    public var yourView: UIView                   = UIView()
    public var yourTextField: UITextField         = UITextField()
    
    public var yourList: [String]                 = []
    
    // Custom variable
    public var BorderColor:String                 = "f5f5f5"
    public var BorderWidth:CGFloat                = 1.0
    public var CornerRadius:CGFloat               = 2
    
    
    
    // Closures
    fileprivate var privateDidSelect: (String, Int) -> () = {listName, index in }
    
    
    

    
    var delegate: myDropDownControllerDelegate?

   
    func reloadDataAction() {
        self.delegate?.reloadData()
    }
    
    
    //  We create view and tableview.
    public func create(pos:position = position.bottom){
        // implement textField Configure
        textFieldConfigure()
        
        myTableView = UITableView()
        self.yourView.insertSubview(myView, at: 0)
        myView.addSubview(myTableView)
        myView.isHidden     = true
        
        myView.translatesAutoresizingMaskIntoConstraints                  = false
        myTableView.translatesAutoresizingMaskIntoConstraints             = false
        
        
        myView.layer.borderColor                                          = UIColor.init(hexString: BorderColor)?.cgColor
        myView.layer.borderWidth                                          = BorderWidth
        myView.layer.cornerRadius                                         = CornerRadius
        
        // Cell Class and Name
        myTableView.register(myDropDownCell.self, forCellReuseIdentifier: "myDropDownCell")
        
        // TableView Configure
        myTableView.separatorInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        myTableView.separatorColor = UIColor.clear
        myTableView.delegate       = self
        myTableView.dataSource     = self
        
        //  Constraint Layout
        myView.leftAnchor.constraint(equalTo:(self.yourTextField.leftAnchor), constant: 5).isActive      = true
        myView.rightAnchor.constraint(equalTo:(self.yourTextField.rightAnchor), constant: -5).isActive   = true
        myView.heightAnchor.constraint(equalToConstant: 140).isActive                                    = true
        
        myTableView.topAnchor.constraint(equalTo: (myView.topAnchor), constant: 0).isActive              = true
        myTableView.leftAnchor.constraint(equalTo: (myView.leftAnchor), constant: 0).isActive            = true
        myTableView.rightAnchor.constraint(equalTo: (myView.rightAnchor), constant: 0).isActive          = true
        myTableView.bottomAnchor.constraint(equalTo: (myView.bottomAnchor), constant: 0).isActive        = true
        
        
        switch pos {
        case .top:
            myView.bottomAnchor.constraint(equalTo: (self.yourTextField.topAnchor), constant: -5).isActive  = true
        case .bottom:
            myView.topAnchor.constraint(equalTo: (self.yourTextField.bottomAnchor), constant: 5).isActive   = true
            
        }
        
    }
    
    public func didSelect(completion: @escaping (_ option: String, _ index: Int) -> ()) {
        privateDidSelect = completion
    }
    
    // textField Configure
    private func textFieldConfigure(){
        yourTextField.delegate = self
    }
    
}

//////////////////////////////////////
///////
///////////  Cell
////////////////
//////////////////////////////////////

class myDropDownCell: UITableViewCell {
    
    var contentTitle = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentTitleConfigure()
        
        self.contentView.addSubview(contentTitle)
        
        // Constraint Layout
        contentTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive        = true
        contentTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive     = true
        contentTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive          = true
        contentTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive    = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentTitleConfigure(){
        contentTitle.font                                           = UIFont(name: "Helvetica", size: 13)
        contentTitle.translatesAutoresizingMaskIntoConstraints      = false
        contentTitle.textColor                                      = UIColor.init(hexString: "2f3640")
    }
    
}


//////////////////////////////////
/////
/////       extension
/////////////////////////////////
/////
//////////////////////////////////



// Extension Class For HEX Color
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}



extension myDropDownController:UITableViewDataSource {
    
    // Table View Row Count
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourList.count
    }
    
    // TableView Cell Content
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myDropDownCell") as! myDropDownCell
        
        cell.selectionStyle                             = .none
        cell.contentTitle.text                          = yourList[indexPath.row]
        
        return cell
    }
    
}


extension myDropDownController:UITableViewDelegate {
    
    // TableView SelectRow Method
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        privateDidSelect("\(self.yourList[indexPath.row])", indexPath.row)
    }
    
}


extension myDropDownController:UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text?.count)
        if textField.text?.count ?? 0 > 0 {
            
            myView.isHidden = false
            
        }else{
            
            myView.isHidden = true
            
        }
        
        return true
    }
    
}
