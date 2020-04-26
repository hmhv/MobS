//
//  CountUpViewController.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/25.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit
import MobS

class CountUpViewController: UIViewController {

    @MobS.Observable(value: 0)
    var count: Int

    @IBOutlet weak var countLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        $count.bind(to: countLabel, keyPath: \.text) { "\($0)" }

//        $count.addObserver(with: countLabel) { (label, count) in
//            label.text = "\(count)"
//        }

//        addObserver { vc in
//            vc.countLabel.text = "\(vc.count)"
//        }

//        MobS.addObserver { [weak self] in
//            guard let self = self else { return }
//            self.countLabel.text = "\(self.count)"
//        }.removed(by: remover)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        count += 1
    }

}
