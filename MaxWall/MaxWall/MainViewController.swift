//
//  MainViewController.swift
//  MaxWall
//
//  Created by HeHe on 16/5/27.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewProgram = TableViewController()
        viewProgram.title = "Program"
        let viewMedia = MediaViewController()
        viewMedia.title = "Media"
        
        //分别声明两个视图控制器
        let program = UINavigationController(rootViewController:viewProgram)
        program.tabBarItem.image = UIImage(named:"Programicon")
        let media = UINavigationController(rootViewController:viewMedia)
        media.tabBarItem.image = UIImage(named:"Mediaicon")
        self.viewControllers = [program,media]
        
        //默认选中的主界面视图
        self.selectedIndex = 0
    }
}
