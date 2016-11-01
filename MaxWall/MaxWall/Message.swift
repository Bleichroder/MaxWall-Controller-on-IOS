//
//  Message.swift
//  MaxWall
//
//  Created by HeHe on 16/6/17.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

class Message {
    var name: String
    var content: String
    var id: String
    var status: String
    
    init?(name: String, content: String, id: String, status: String){
        self.name = name
        self.content = content
        self.id = id
        self.status = status
    }
}