//
//  Reference.swift
//  MaxWall
//
//  Created by HeHe on 16/5/27.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import Foundation
//工具类,放置一些经常用到的方法
//通过userDefault存储数据
class Reference{
    
    func cacheSetString(key: String,value: String){
        let userInfo = NSUserDefaults()
        userInfo.setValue(value, forKey: key)
    }
    
    func cacheGetString(key: String) -> String{
        let userInfo = NSUserDefaults()
        let tmpSign = userInfo.stringForKey(key)
        return tmpSign!
    }
}
