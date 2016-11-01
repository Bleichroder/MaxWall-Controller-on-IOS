//
//  MessageViewController.swift
//  MaxWall
//
//  Created by HeHe on 16/6/16.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class MessageViewController: UITableViewController, WebSocketDelegate {
    
    var re: Reference = Reference()
    var address: String = String()
    var socket = WebSocket(url: NSURL(string: "")!)
    var json: JSON!
    var msgjson: [JSON] = [JSON]()
    var msg = [Message]()
    var getmsg: String = String()
    var selectedIndex: Int?
    var btnclk = false
    var userLogin: [String : NSObject] = [:]
    let getmessage = ["body":["keyWords":""], "guid":"M-91", "type":"QUERYMESSAGE"]

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
            var a = "0"
            if msg[selectedIndex!].status == "0" {
                a = "1"
                msg[selectedIndex!].status = a
            }
            else {
                a = "0"
                msg[selectedIndex!].status = a
            }
            let b = Int(a)
            let id = msg[selectedIndex!].id
            let contentxml = msg[selectedIndex!].content
            let permanentrun = String(msgjson[selectedIndex!]["permanentRun"])
            let messagename = String(msgjson[selectedIndex!]["messageName"])
            let messagePositionXML = String(msgjson[selectedIndex!]["messagePositionXML"])
            let zorder = String(msgjson[selectedIndex!]["zorder"])
            let idd = Int(id)
            let perr = Int(permanentrun)
            let zorr = Int(zorder)
            let enablemsg = ["body":["id":idd!, "messageContentXML":contentxml, "status":b!, "permanentRun":perr!, "zorder":zorr!, "messageName":messagename, "messagePositionXML":messagePositionXML], "guid":"M-80", "type":"EDITMESSAGESTATUS"]
            json = JSON(userLogin)
            print("\(json)")
            socket.writeString("\(json!)")
            json = JSON(enablemsg)
            print("\(json)")
            socket.writeString("\(json!)")
        }
        else {
            json = JSON(userLogin)
            print("\(json)")
            socket.writeString("\(json!)")
            json = JSON(getmessage)
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
        
        if jsonparse["type"] == "EDITMESSAGESTATUS"{
            btnclk = false
            print("Received text: \(text)")
            socket.disconnect()
            return
        }
        
        if jsonparse["type"] == "QUERYMESSAGE"{
            var i = 0
            while jsonparse["body"]["messageItemInfo"][i] != nil {
                let msgid = jsonparse["body"]["messageItemInfo"][i]["id"]
                let msgname = jsonparse["body"]["messageItemInfo"][i]["messageName"]
                let msgcontent = jsonparse["body"]["messageItemInfo"][i]["messageContentXML"]
                let msgstatus = jsonparse["body"]["messageItemInfo"][i]["status"]
                msgjson.append(jsonparse["body"]["messageItemInfo"][i])
                i += 1
                let msgidd = String(msgid)
                let msgnamee = String(msgname)
                let msgcontentt = String(msgcontent)
                let msgstatuss = String(msgstatus)
                
                msg += [Message(name: msgnamee, content: msgcontentt, id: msgidd, status: msgstatuss)!]
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Messagecell", forIndexPath: indexPath) as! MessageViewCell

        let msgnow = msg[indexPath.row]
        
        cell.messageName.text = msgnow.name
        cell.messageContent.text = msgnow.content
        if msgnow.status == "1" {
            //selectedIndex = indexPath.row
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedIndex = indexPath.row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if msg[indexPath.row].status == "0" {
            cell?.accessoryType = .Checkmark
        }
        else {
            cell?.accessoryType = .None
        }
        
        btnclk = true
        socket.delegate = self
        socket.selfSignedSSL = true
        socket.connect()
    }

}
