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

    @MobS.State(initialState: 0)
    var count: Int

    @IBOutlet weak var countLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        $count.bind(to: countLabel, keyPath: \.text) { "\($0)" }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        count += 1
    }

}
