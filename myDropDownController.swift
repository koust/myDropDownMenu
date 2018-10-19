//
//  myDropDownController.swift
//  myDropDownMenu
//
//  Created by Batuhan Saygili on 1.10.2018.
//  Copyright © 2018 koust. All rights reserved.
//

import UIKit


// Drop down position
public enum position {
    case top
    case bottom
}

// --> Main Controller 
// ----> All variable
// ------> Create
// ------> Closures
// ------> Show Method
// ------> Hide Method
// ------> Search Filter Method
// ------> Background and Drop Down Animation

// --> Main Cell Class


public class myDropDownController: UIViewController {

    
    private var myView : UIView                   = UIView()
    private var dropDownHeightConstant : NSLayoutConstraint?
    private var searchList:[String]               = []
    private var backgroundView:UIView?
    
    //  We create table view and reload data
    fileprivate var myTableView : UITableView! {
        didSet {
            self.myTableView.reloadData()
        }
    }
    
    // Configure
    public var yourView: UIView                                 = UIView()
    public var yourTextField: UITextField                       = UITextField()
    public var yourDropDownCell: UITableViewCell.Type           = myDropDownCell.self
    public var yourDropDownforCellIdentifier                    = "myDropDownCell"
    public var yourList: [String]                               = []
    public var alwaysOpen:Bool                                  = true
    
    // Custom variable
    public var BorderColor:String                               = "f5f5f5"
    public var BorderWidth:CGFloat                              = 1.0
    public var CornerRadius:CGFloat                             = 10
    public var dropDownHeight:CGFloat                           = 0
    public var dropDownAnimation:UIViewAnimationOptions         = [.curveEaseInOut]
    
    
    // Closures
    fileprivate var privateDidSelect: (String, Int) -> ()       = {listName, index in }
    fileprivate var privateFilterList: ([String]) -> ()         = {filterList in}
    


    
    
    //  We create view and tableview.
    public func create(pos:position = position.bottom){
        // implement textField Configure
        textFieldConfigure()
        myTableView             = UITableView()
        self.yourView.insertSubview(myView, at: 0)
        myView.layer.zPosition          = 5
        yourTextField.layer.zPosition   = 5
        yourView.layer.zPosition        = 1
        myView.addSubview(myTableView)
        
        myView.translatesAutoresizingMaskIntoConstraints                  = false
        myTableView.translatesAutoresizingMaskIntoConstraints             = false
        
        myView.clipsToBounds                                              = true
        myView.layer.borderColor                                          = UIColor.init(hexString: BorderColor)?.cgColor
        myView.layer.borderWidth                                          = BorderWidth
        myView.layer.cornerRadius                                         = CornerRadius
        
        
        yourTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //  myView.dropShadow(color: UIColor.black, opacity: 1, offSet: CGSize(width: -3, height: -1), radius: 3, scale: true)
        
        // Cell Class and Name
        myTableView.register(yourDropDownCell, forCellReuseIdentifier:yourDropDownforCellIdentifier)
        
        // TableView Configure
        myTableView.separatorInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        myTableView.separatorColor = UIColor.init(hexString: "#f5f5f5")
        myTableView.delegate       = self
        myTableView.dataSource     = self
        
        //  Constraint Layout
        myView.leftAnchor.constraint(equalTo:(self.yourTextField.leftAnchor), constant: 5).isActive      = true
        myView.rightAnchor.constraint(equalTo:(self.yourTextField.rightAnchor), constant: -5).isActive   = true
        
        dropDownHeightConstant              = myView.heightAnchor.constraint(equalToConstant: dropDownHeight)
        dropDownHeightConstant?.isActive    = true
        
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
    
    public func didSelect(completion: @escaping (_ listName: String, _ index: Int) -> ()) {
        privateDidSelect = completion
    }
    
    public func filterList(completion: @escaping(_ filterList:[String]) -> ()) {
        privateFilterList = completion
    }
    
    public func show(){
        dropDownAnimation(status:true)
    }
    
    public func close(){
        dropDownAnimation(status: false)
    }
    
    
    // textField Configure
    private func textFieldConfigure(){
        yourTextField.delegate = self
    }
    
    
    private func searchKeyword(){
        if yourTextField.text?.count ?? 0 > 1 {
            searchList = yourList.filter{$0.lowercased().contains(yourTextField.text?.lowercased() ?? "")}
        }else{
            searchList.removeAll()
        }
    }
    
    private func viewBackground(){
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: yourView.frame.size.width, height: yourView.frame.size.height))
        
        yourView.insertSubview(backgroundView!, at: 0)
        
        backgroundView?.backgroundColor = UIColor.init(hexString: "#000000")
        backgroundView?.alpha           = 0.5
        
        backgroundView?.layer.zPosition = 4
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        backgroundView?.addGestureRecognizer(gesture)
        
    }
    
    @objc private func viewTapped(){
        self.animationHide()
    }
    
    private func dropDownAnimation(status:Bool){
    
        // Status : true -> Show || false -> Hide
        UIView.animate(withDuration: 0.3, delay:0, options: [dropDownAnimation], animations: {
                if status{
                    self.dropDownHeight                      = 140
                    self.dropDownHeightConstant?.constant    = self.dropDownHeight
                }else{
                    self.dropDownHeight                      = 0
                    self.dropDownHeightConstant?.constant    = self.dropDownHeight
                }
                self.yourView.layoutIfNeeded()
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
        
    }
    
    
    private func animationHide(){
        self.backgroundView?.removeFromSuperview()
        
        self.yourView.endEditing(true)
        self.dropDownAnimation(status:false)
        
        self.searchList = self.searchList.map{$0.lowercased()}
        // it gets first element in the array if the content does not match
        if !self.searchList.contains(yourTextField.text?.lowercased() ?? "") {
            self.yourTextField.text = self.searchList.first
            privateDidSelect("\(self.searchList[0])", 0)
        }
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

extension myDropDownController:UITableViewDataSource {
    
    
    // Table View Row Count
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchList.count == 0 {
            return 1
        }
        return searchList.count
    }
    
    // TableView Cell Content
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: yourDropDownforCellIdentifier) as! myDropDownCell
        if searchList.count == 0 {
         
            cell.selectionStyle                             = .none
            cell.contentTitle.text                          = "We could not find"
            return cell
        }
        cell.selectionStyle                             = .none
        cell.contentTitle.text                          = searchList[indexPath.row]
        return cell
    }
    
}


extension myDropDownController:UITableViewDelegate {
    
    // TableView SelectRow Method
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchList.count > 0 {
            privateDidSelect("\(self.searchList[indexPath.row])", indexPath.row)
            privateFilterList(searchList)
        }
    }
    
 
    

}


extension myDropDownController:UITextFieldDelegate {
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            self.searchKeyword()
        
            if searchList.count > 0 {
                
                self.dropDownAnimation(status: true)
            }else{
                
                self.dropDownAnimation(status: alwaysOpen)
            }
            self.myTableView.reloadData()
     
    }
    

    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.viewBackground()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.animationHide()


        return true
    }
}


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


extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds      = false
        layer.shadowColor        = color.cgColor
        layer.shadowOpacity      = opacity
        layer.shadowOffset       = offSet
        layer.shadowRadius       = radius
        layer.shadowPath         = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize    = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

