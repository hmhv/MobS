//
//  TodoCell.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit
import MobS

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoSwitch: UISwitch!

    var cellModel: TodoCellModel? {
        didSet {
            remover.removeAll()

            if let cellModel = cellModel {
                cellModel.$todo.addUpdater(with: self) { (cell, todo) in
                    cell.todoLabel.text = todo.title
                    cell.todoSwitch.isOn = todo.done
                }
            }
        }
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        cellModel?.toggle()
    }

}
