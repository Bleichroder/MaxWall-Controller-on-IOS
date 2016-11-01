//
//  TableViewController.swift
//  MaxWall
//
//  Created by HeHe on 16/5/30.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class TableViewController: UITableViewController, WebSocketDelegate {

    var re: Reference = Reference()
    var address: String = String()
    var socket = WebSocket(url: NSURL(string: "")!)
    var program = [Program]()
    var json: JSON!
    var selectedIndex: Int?
    var btnclk = false
    var userLogin: [String : NSObject] = [:]
    let playstate = ["body":"", "guid":"M-9", "type":"NOTIFYPLAYSTATE"]
    let heartbeat = ["body":"", "guid":"", "type":"MASTERHEARTBEAT"]
    let getmediatree = ["body":["parentID":0], "guid":"M-36", "type":"GETCHILDMEDIAFOLDERLIST"]
    let loadprogram = ["body":["id":210], "guid":"M-27", "type":"LOADPROGRAM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        address = re.cacheGetString("address")
        userLogin = ["body":["userName":re.cacheGetString("user"),"userPassword":re.cacheGetString("password")], "guid":"M-0", "type":"QUERYUSERLOGIN"]
        socket = WebSocket(url: NSURL(string: address)!)
        socket.delegate = self
        socket.selfSignedSSL = true
        socket.connect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Websocket Delegate Methods.
    func websocketDidConnect(ws: WebSocket){
        print("websocket is connected")
        if btnclk {
            let playProgram = ["body":["id": Int(program[selectedIndex!].id)!], "guid":"M-79", "type":"PLAYPROGRAM"]
            json = JSON(userLogin)
            print("\(json)")
            socket.writeString("\(json!)")
            json = JSON(playProgram)
            print("\(json)")
            socket.writeString("\(json!)")
        }
        else {
            json = JSON(userLogin)
            print("\(json)")
            socket.writeString("\(json!)")
            json = JSON(playstate)
            print("\(json)")
            socket.writeString("\(json!)")
            json = JSON(loadprogram)
            print("\(json)")
            socket.writeString("\(json!)")
        }
    }
    func websocketDidDisconnect(ws: WebSocket, error: NSError?){
        if let e = error{
            print("websocket is disconnect: \(e.localizedDescription)")
        }
        else{
            print("websocket is disconnect")
        }
    }
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        var jsonparse = JSON.parse(text)
        
        if jsonparse["type"] == "PLAYPROGRAM"{
            btnclk = false
            print("Received text: \(text)")
            socket.disconnect()
            return
        }
        
        if jsonparse["type"] == "PLAYSCHEDULER"{
            var i = 0
            program = [Program]()
            while jsonparse["body"]["program"][i]["name"] != nil {
                let programname = jsonparse["body"]["program"][i]["name"]
                let programid = jsonparse["body"]["program"][i]["ID"]
                let programplay = jsonparse["body"]["program"][i]["playing"]
                i += 1
                let programnamee = String(programname)
                let programidd = String(programid)
                let programplayy = Bool(programplay)
                
                program += [Program(name: programnamee, photo: UIImage(named: "default"), id: programidd, isplaying: programplayy)!]
            }
            self.tableView!.reloadData()
            print("Received text: \(text)")
            socket.disconnect()
            return
        }
        
        if jsonparse["type"] == "SERVERHEARTBEAT" || jsonparse["type"] == "NOWPLAYMESSAGE" || jsonparse["type"] == "HARDWARENOFITY" || jsonparse["type"] == "MAXWALLSNAPSHOT"{
            return
        }
        print("Received text: \(text)")
    }
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
    }
    
    // MARK: Table View data
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return program.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tablecell", forIndexPath: indexPath) as! TableViewCell
        let programnow = program[indexPath.row]
        
        cell.programName.text = programnow.name
        cell.programImage.image = programnow.photo
        if program[indexPath.row].isplaying == true {
            selectedIndex = indexPath.row
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedIndex = indexPath.row
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        btnclk = true
        socket.delegate = self
        socket.selfSignedSSL = true
        socket.connect()
    }
}
