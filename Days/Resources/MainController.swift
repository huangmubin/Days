//
//  MainController.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        let key = Keyboard()
        key.update(title: "这是一个标题")
        key.update(text: "这些新的内容可以更新吗？这些新的内容可以更新吗？我最关新的是长度啊。这些新的内容可以更新吗？我最关新的是长度啊。这些新的内容可以更新吗？我最关新的是长度啊。")
        key.delegate = self
        key.push()
        */
        let key = KeyboardTime()
        
        key.delegate = self
        key.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        print(board.value)
        return nil
    }
    
}
