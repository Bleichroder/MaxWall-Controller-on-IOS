//
//  Program.swift
//  MaxWall
//
//  Created by HeHe on 16/5/30.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

class Program {
    var name: String
    var photo: UIImage?
    var id: String
    var isplaying: Bool
    
    init?(name: String, photo: UIImage?, id: String, isplaying: Bool){
        self.name = name
        self.photo = photo
        self.id = id
        self.isplaying = isplaying
    }
}
