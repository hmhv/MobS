//
//  TodoDetailViewController.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit
import SoftUIView

class TodoDetailViewController: UIViewController {

    var viewModel: TodoListViewModel!
    var todoCellModel: TodoCellModel!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var changeView: SoftUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationItem.title = "Todo Detail"
        view.backgroundColor = UIColor(cgColor: SoftUIView.defalutMainColorColor)

        let buttonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo))
        navigationItem.rightBarButtonItem = buttonItem

        changeView.addLabel(text: "Commit")
        changeView.addTarget(self, action: #selector(commit), for: .touchUpInside)

        textView.text = todoCellModel.todo.title
        doneSwitch.isOn = todoCellModel.todo.done
    }

    @objc func commit() {
        todoCellModel.update(title: textView.text ?? "", done: doneSwitch.isOn)
        navigationController?.popViewController(animated: true)
    }

    @objc func deleteTodo() {
        viewModel.delete(cellModel: todoCellModel)
        navigationController?.popViewController(animated: true)
    }

}
