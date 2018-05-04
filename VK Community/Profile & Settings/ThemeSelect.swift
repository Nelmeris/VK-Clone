//
//  ThemeSelect.swift
//  VK Community
//
//  Created by Артем on 04.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit

class ThemeSelect: UITableViewController {
    @IBOutlet weak var lightTheme: UITableViewCell!
    
    @IBOutlet weak var darkTheme: UITableViewCell!
    
    override func viewDidLoad() {
        if ThemeManager.currentTheme() == .Black {
            lightTheme.accessoryType = .none
            darkTheme.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            lightTheme.accessoryType = .checkmark
            darkTheme.accessoryType = .none
            
            ThemeManager.applyTheme(theme: .White)
        } else {
            lightTheme.accessoryType = .none
            darkTheme.accessoryType = .checkmark
            
            ThemeManager.applyTheme(theme: .Black)
        }
    }
}
