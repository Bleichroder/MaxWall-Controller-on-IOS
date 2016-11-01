//
//  MediaViewController.swift
//  MaxWall
//
//  Created by HeHe on 16/5/31.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class MediaViewController: UITableViewController, WebSocketDelegate {
    
    @IBOutlet weak var previousBtn: UIButton!
    
    var re: Reference = Reference()
    var address: String = String()
    var socket = WebSocket(url: NSURL(string: "")!)
    var mediacell = [mediapage]
    var page = 1
    var dis = 0
    var imagenb = 0
    var imagect = 0
    var json: JSON!
    var btnclk = false
    var lock = false
    var selectcell: Int?
    var userLogin: [String : NSObject] = [:]
    var countriesinEurope = ["France","Spain","Germany"]
    var countriesinAsia = ["Japan","China","India"]
    var countriesInSouthAmerica = ["Argentia","Brasil","Chile"]
    let getmediatree = ["body":["parentID":0], "guid":"M-36", "type":"GETCHILDMEDIAFOLDERLIST"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousBtn.enabled = false
        
        address = re.cacheGetString("address")
        userLogin = ["body":["userName":re.cacheGetString("user"),"userPassword":re.cacheGetString("password")], "guid":"M-0", "type":"QUERYUSERLOGIN"]
        socket = WebSocket(url: NSURL(string: address)!)
        socket.delegate = self
        socket.selfSignedSSL = true
        socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func previous() {
        page -= 1
        self.tableView!.reloadData()
    }
    
    // MARK: Websocket Delegate Methods.
    func websocketDidConnect(ws: WebSocket){
        print("websocket is connected")
        if btnclk {
            json = JSON(userLogin)
            print("\(json)")
            socket.writeString("\(json!)")
            page += 1
            lock = true
            dis = 0
            let a = mediacell[page-1][selectcell!].folderid
            let b = Int(a)
            if mediacell[page-1][selectcell!].hasmedia {
                let getmedia = ["body":["id":b!, "keyword":""], "guid":"M-42", "type":"GETMEDIAFILELIST"]
                json = JSON(getmedia)
                print("\(json)")
                socket.writeString("\(json!)")
            }
            else {
                dis = 2
            }
            if mediacell[page-1][selectcell!].haschildfolder {
                let getfolder = ["body":["parentID":b!], "guid":"M-36", "type":"GETCHILDMEDIAFOLDERLIST"]
                json = JSON(getfolder)
                print("\(json)")
                socket.writeString("\(json!)")
            }
            else {
                dis = 1
            }
            let med = [MediaInfo]()
            if mediacell.endIndex > page {
                mediacell[page] = med
            }
            else {
                mediacell.append(med)
            }
        }
        else {
            json = JSON(userLogin)
            print("\(json)")
            socket.writeString("\(json!)")
            json = JSON(getmediatree)
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
        
        if jsonparse["type"] == "GETMEDIAFILEINFO" {
            print("Received text: \(text)")
            var b = [UInt8]()
            var i = 0
            while jsonparse["body"]["thumbnailPix"]["pixValue"][i] != nil {
                let a = String(jsonparse["body"]["thumbnailPix"]["pixValue"][i])
                let c = UInt8(a)
                b.append(c!)
                i += 1
            }
            let f = b.count
            let e = NSData(bytes: b, length: f)
            let pic = UIImage(data: e)
            for mi in mediacell[page] {
                if mi.mediaid == String(jsonparse["body"]["fileId"]) {
                    mi.mediaimage = pic
                    imagect += 1
                    self.tableView!.reloadData()
                    if imagect == imagenb {
                        socket.disconnect()
                        imagect = 0
                    }
                }
            }
        }
        
        if btnclk && lock {
            if mediacell[page-1][selectcell!].hasmedia {
                if jsonparse["type"] == "GETMEDIAFILELIST" {
                    var i = 0
                    imagenb = 0
                    var noimage = false
                    while jsonparse["body"]["infolist"][i]["fileName"] != nil {
                        let cellname = String(jsonparse["body"]["infolist"][i]["fileName"])
                        let dutime = String(jsonparse["body"]["infolist"][i]["durationtime"])
                        let size = String(jsonparse["body"]["infolist"][i]["size"])
                        let id = String(jsonparse["body"]["infolist"][i]["fileId"])
                        mediacell[page] += [MediaInfo(medianame: cellname, durationtime: dutime, mediasize: size, mediaid: id, mediaimage: UIImage(named: "Mediaicon"), isfolder: false, folderid: "", hasmedia: false, haschildfolder: false)!]
                        if jsonparse["body"]["infolist"][i]["bHasThumbnailPix"] == true {
                            let a = Int(id)
                            let thumbnail = ["body":["idlist":a!], "guid":"M-48", "type":"GETMEDIAFILEINFO"]
                            json = JSON(thumbnail)
                            print("\(json)")
                            socket.writeString("\(json!)")
                            imagenb += 1
                        }
                        else {
                            noimage = true
                        }
                        i += 1
                    }
                    self.tableView!.reloadData()
                    print("Received text: \(text)")
                    if dis == 1 {
                        btnclk = false
                        lock = false
                        if noimage {
                            socket.disconnect()
                        }
                        return
                    }
                }
            }
            if mediacell[page-1][selectcell!].haschildfolder {
                if jsonparse["type"] == "GETCHILDMEDIAFOLDERLIST"{
                    var i = 0
                    while jsonparse["body"]["folderInfo"][i]["folderName"] != nil {
                        let cellname = String(jsonparse["body"]["folderInfo"][i]["folderName"])
                        let id = String(jsonparse["body"]["folderInfo"][i]["folderID"])
                        let haschild = Bool(jsonparse["body"]["folderInfo"][i]["hasChild"])
                        let hasmedia = Bool(jsonparse["body"]["folderInfo"][i]["hasMedia"])
                        mediacell[page] += [MediaInfo(medianame: cellname, durationtime: "", mediasize: "", mediaid: "", mediaimage: UIImage(named: "Programicon"), isfolder: true, folderid: id, hasmedia: hasmedia, haschildfolder: haschild)!]
                        i += 1
                    }
                    self.tableView!.reloadData()
                    print("Received text: \(text)")
                    if dis == 0 {
                        btnclk = false
                        lock = false
                        return
                    }
                    if dis == 2 {
                        btnclk = false
                        lock = false
                        socket.disconnect()
                        return
                    }
                }
            }
        }
        else {
            if jsonparse["type"] == "GETCHILDMEDIAFOLDERLIST"{
                var i = 0
                var med = [MediaInfo]()
                while jsonparse["body"]["folderInfo"][i]["folderName"] != nil {
                    let cellname = String(jsonparse["body"]["folderInfo"][i]["folderName"])
                    let id = String(jsonparse["body"]["folderInfo"][i]["folderID"])
                    let haschild = Bool(jsonparse["body"]["folderInfo"][i]["hasChild"])
                    let hasmedia = Bool(jsonparse["body"]["folderInfo"][i]["hasMedia"])
                    med += [MediaInfo(medianame: cellname, durationtime: "", mediasize: "", mediaid: "", mediaimage: UIImage(named: "Programicon"), isfolder: true, folderid: id, hasmedia: hasmedia, haschildfolder: haschild)!]
                    i += 1
                }
                mediacell.append([MediaInfo]())
                mediacell[page] += med
                self.tableView!.reloadData()
                print("Received text: \(text)")
                socket.disconnect()
                return
            }
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
        if mediacell.count == 1 {
            return 0
        }
        else {
            return mediacell[page].count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Mediacell", forIndexPath: indexPath) as! MediaViewCell

        if page == 1 {
            previousBtn.enabled = false
        }
        else if page > 1 {
            previousBtn.enabled = true
        }
        cell.mediaName.text = mediacell[page][indexPath.row].medianame
        cell.mediaImage.image = mediacell[page][indexPath.row].mediaimage
        var unit: String = "B"
        var size = Int(mediacell[page][indexPath.row].mediasize)
        if size != nil {
            if size > 1023 && size < 1048576 {
                unit = "KB"
                size = size!/1024
            }
            else if size > 1048576 && size < 1073741824 {
                unit = "MB"
                size = size!/1048576
            }
            cell.mediaSize.text = String(size!)+unit
        }
        else {
            cell.mediaSize.text = mediacell[page][indexPath.row].mediasize
        }
        cell.durantionTime.text = mediacell[page][indexPath.row].durationtime
        
        if mediacell[page][indexPath.row].hasmedia || mediacell[page][indexPath.row].haschildfolder {
            cell.accessoryType = .DisclosureIndicator
        }
        else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        //let cell = tableView.cellForRowAtIndexPath(indexPath)
        if mediacell[page][indexPath.row].hasmedia || mediacell[page][indexPath.row].haschildfolder {
            selectcell = indexPath.row
            btnclk = true
            address = re.cacheGetString("address")
            socket = WebSocket(url: NSURL(string: address)!)
            socket.delegate = self
            socket.selfSignedSSL = true
            socket.connect()
        }
    }
}
