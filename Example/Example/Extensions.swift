//
//  Extensions.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/25.
//  Copyright © 2020 hmhv. All rights reserved.
//

import SoftUIView

extension SoftUIView {

    func addLabel(text: String) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.init(name: "AvenirNext-Bold", size: 13)
        label.textColor = .darkText
        label.text = text

        setContentView(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}


extension UIViewController {

    static func newVC() -> UIViewController {
        let sb = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let vc = sb.instantiateInitialViewController() else {
            fatalError("invalid storyboard")
        }
        return vc
    }

}
