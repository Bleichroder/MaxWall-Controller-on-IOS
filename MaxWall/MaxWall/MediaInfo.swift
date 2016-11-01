//
//  MediaInfo.swift
//  MaxWall
//
//  Created by HeHe on 16/6/1.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

class MediaInfo {
    var medianame: String
    var durationtime: String
    var mediasize: String
    var mediaid: String
    var mediaimage: UIImage?
    var isfolder: Bool
    var folderid: String
    var hasmedia: Bool
    var haschildfolder: Bool
    
    init?(medianame: String, durationtime: String, mediasize: String, mediaid: String, mediaimage: UIImage?, isfolder: Bool, folderid: String, hasmedia: Bool, haschildfolder: Bool){
        self.medianame = medianame
        self.durationtime = durationtime
        self.mediasize = mediasize
        self.mediaid = mediaid
        self.mediaimage = mediaimage
        self.isfolder = isfolder
        self.folderid = folderid
        self.hasmedia = hasmedia
        self.haschildfolder = haschildfolder
    }
}

var mediapage = [MediaInfo]()