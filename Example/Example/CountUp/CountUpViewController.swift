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

        $count.addObserver(with: self) { (self, count) in
            self.countLabel.text = "\(count)"
        }

//        let removable = $count.addObserver { [weak self] in
//            guard let self = self else { return }
//            self.countLabel.text = "\(self.count)"
//        }
//        removable.removed(by: remover)

//        $count.addObserver { [weak self] in
//            guard let self = self else { return }
//            self.countLabel.text = "\(self.count)"
//        }.removed(by: remover)

//        $count.bind(to: countLabel, keyPath: \.text) { (count) in
//            "\(count)"
//        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        count += 1
    }

}
