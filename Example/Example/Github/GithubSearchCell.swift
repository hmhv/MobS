//
//  GithubSearchCell.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/05/07.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit

class GithubSearchCell: UITableViewCell {

    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!

    var repo: GithubRepo? {
        didSet {
            if let repo = repo {
                repoLabel.text = repo.fullName
                languageLabel.text = repo.language
            }
        }
    }
}
