//
//  ViewController.swift
//  SplitMessage
//
//  Created by Raza Khan on 12/03/19.
//  Copyright © 2019 Raza Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textFieldMessage: UITextField!

    let characterLength = 50

    var arrayMessage = [String]()
    
    @IBOutlet var bottomConstraintOfTextFieldView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title =  "Split Message"
        
        // Dismiss Keyboard when touches chat area..
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureForDismissKeyboard(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        //Keyboard Notification
        let center = NotificationCenter.default
        
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(notification:)),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillChange(notification:)),
                           name: UIResponder.keyboardWillChangeFrameNotification,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(notification:)),
                           name:UIResponder.keyboardWillHideNotification,
                           object: nil)
        
        center.addObserver(self, selector: #selector(tapGestureForDismissKeyboard(_:)), name:NSNotification.Name(rawValue: "dismissKeyboard"), object: nil)
        
    }
    
    @objc func tapGestureForDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.bottomConstraintOfTextFieldView.constant = 0
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Scroll to Bottom TableView -
    private func scrollToBottom() {
        self.tableView.reloadData()
        if self.arrayMessage.count > 0 {
            let indexPath = IndexPath(row: self.arrayMessage.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK:- KeyBoard Notification -
    @objc func keyboardWillShow(notification: NSNotification) {
        if  let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: duration, animations: {
                    self.bottomConstraintOfTextFieldView.constant = keyboardSize.height
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                })
            }
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if  let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: duration, animations: {
                    self.bottomConstraintOfTextFieldView.constant = keyboardSize.height
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if  let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            UIView.animate(withDuration: duration, animations: {
                self.bottomConstraintOfTextFieldView.constant = 0;
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //MARK:- Split message logic here -
    private func updateSplitMessagesInUIIfNeeded() {
        if let stringMessage = self.textFieldMessage.text {
            
            let whitespace = CharacterSet.whitespaces
            let range = stringMessage.rangeOfCharacter(from: whitespace)
            // range will be nil if no whitespace is found
            if range != nil {
                /** Check here if message text is greater than 50 characters **/
                if stringMessage.count > characterLength {
                    let wordArray = stringMessage.components(separatedBy: " ")
                    print(wordArray)
                    var appendString = ""
                    var tempData = [String]()
                    
                    for word in wordArray {
                        /** here is the logic where sentence word split but not like ( message = mess age) **/
                        appendString.append(" \(word)")
                        if appendString.count > characterLength {
                            tempData.append(appendString)
                            appendString = ""
                        }
                    }
                    
                    /** here we can check remaining string data **/
                    if appendString.count > 0 {
                        tempData.append(appendString)
                    }
                    /** here we need to add 1\2 from sentences **/
                    for i in 0..<tempData.count{
                        arrayMessage.append("\(i+1)/\(tempData.count) \(tempData[i])")
                    }
                } else {
                    arrayMessage.append(stringMessage)
                }
                self.textFieldMessage.text = ""
            } else {
                
                if stringMessage.count <= characterLength {
                    arrayMessage.append(stringMessage)
                    self.textFieldMessage.text = ""
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: "Please provide valid message !", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    })
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension  ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let trimmedString = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedString?.count)! > 0 {
            self.updateSplitMessagesInUIIfNeeded()
            self.scrollToBottom()
        }
        return false
    }
}

extension ViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.arrayMessage.count > 0  {
            self.tableView.tableHeaderView = nil;
        }
        else {
            var frame = self.tableView.frame
            frame.origin = CGPoint(x: 0,y :0)
            frame.size.height = 300
            let view = UIView.init(frame: frame)
            view.backgroundColor = UIColor.clear

            let margin = UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10)
            let label1 = UILabel(frame: CGRect(x: margin.left, y: margin.top, width: view.frame.width-(margin.left+margin.right), height: 50))
            label1.font = UIFont.boldSystemFont(ofSize: 20)
            label1.numberOfLines = 0
            label1.textAlignment = .center
            label1.textColor = .darkGray
            label1.text = "No Message found !"
            let label1NewSize = label1.sizeThatFits(CGSize(width: label1.frame.width, height: CGFloat.greatestFiniteMagnitude))
            frame.size.height = margin.top + label1NewSize.height + margin.bottom
            view.frame = frame
            label1.frame = CGRect(x: margin.left, y: margin.top, width: label1.frame.width, height: label1NewSize.height)

            view.addSubview(label1)
            self.tableView.tableHeaderView = view;
        }
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arrayMessage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        cell.messageString = self.arrayMessage[indexPath.row]

        return cell;
    }

}

extension String {

    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}
