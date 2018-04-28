//
//  Authorization.swift
//  VK Additional Application
//
//  Created by Артем on 27.04.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class Authorization: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Сокрытие пароля
        passwordInput.isSecureTextEntry = true
        
        //Настройка кнопки
        authButton.layer.cornerRadius = 10
        authButton.layer.borderWidth = 0.1
        authButton.layer.borderColor = (UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)).cgColor
        authButton.clipsToBounds = true
        
        //Настройка окна
        authView.layer.cornerRadius = 10
        authView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

