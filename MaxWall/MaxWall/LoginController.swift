//
//  ViewController.swift
//  MaxWall
//
//  Created by HeHe on 16/5/27.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

import Starscream
import SwiftyJSON

class LoginController: UIViewController, WebSocketDelegate, UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var loginimage: UIImageView!
    @IBOutlet weak var ip: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func close(sender: AnyObject) {
        ip.resignFirstResponder()
        user.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    var socket = WebSocket(url: NSURL(string: "")!)
    var json: JSON!
    var loginsuccess = false
    var ref: Reference = Reference()
    var userLogin: [String : NSObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginimage.image = UIImage(named: "Loginphoto")
        ip.delegate = self
        user.delegate = self
        password.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: (Selector("keyboardDidShow")), name: UIKeyboardDidShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: (Selector("keyboardDidHide")), name: UIKeyboardDidHideNotification, object: self.view.window)
        //loginbutton.enabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginBtn() {
        if (ip.text != "" && user.text != "" && password.text != "") {
            loginsuccess = true
            self.ref.cacheSetString("address", value: "wss://" + ip.text! + ":7681" + "/test")
            let a = user.text!
            let b = password.text!
            userLogin = ["body":["userName":a,"userPassword":b], "guid":"M-0", "type":"QUERYUSERLOGIN"]
            self.ref.cacheSetString("user", value: a)
            self.ref.cacheSetString("password", value: b)
            socket = WebSocket(url: NSURL(string: "wss://" + ip.text! + "/test")!)
            socket.delegate = self
            socket.selfSignedSSL = true
            socket.connect()
        }
        else {
            let alert:UIAlertController = UIAlertController(title:nil, message:"Your input is validation",preferredStyle:UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Keyboard Return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        ip.resignFirstResponder()
        user.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    func keyboardDidShow() {
        UIView.animateWithDuration(0.5, animations: {self.view.frame.origin.y = -250})
    }
    
    func keyboardDidHide() {
        UIView.animateWithDuration(0.5, animations: {self.view.frame.origin.y = 0})
    }
    
    /*func textFieldDidEndEditing(textField: UITextField) {
        /*if loginsuccess {
        }
        else {
            self.ref.cacheSetString("address", value: "wss://" + ip.text! + ":7681" + "/test")
            socket = WebSocket(url: NSURL(string: "wss://" + ip.text! + ":7681" + "/test")!)
            socket.delegate = self
            socket.selfSignedSSL = true
            socket.connect()
        }*/
        ip.resignFirstResponder()
        user.resignFirstResponder()
        password.resignFirstResponder()
    }*/
    
    // MARK: Websocket Delegate Methods.
    func websocketDidConnect(ws: WebSocket){
        print("websocket is connected")
        json = JSON(userLogin)
        print("\(json)")
        socket.writeString("\(json!)")
    }
    func websocketDidDisconnect(ws: WebSocket, error: NSError?){
        if let e = error{
            print("websocket is disconnect: \(e.localizedDescription)")
        }
        else{	
            print("websocket is disconnect")
        }
        self.performSegueWithIdentifier("successlogin", sender: self)
    }
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        var json1 = JSON.parse(text)
        
        if json1["body"]["loginSuccess"] == true {
            socket.disconnect()
        }
        else if json1["body"]["loginSuccess"] == false {
            let alert:UIAlertController = UIAlertController(title:nil, message:"websocket connected failed",preferredStyle:UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if json1["type"] == "SERVERHEARTBEAT" || json1["type"] == "NOWPLAYMESSAGE" || json1["type"] == "HARDWARENOFITY" || json1["type"] == "MAXWALLSNAPSHOT"{
            return
        }
        
        print("Received text: \(text)")
    }
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
    }

}

