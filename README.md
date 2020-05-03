# MobS

Simple, safe state management for swift

[![Platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)](https://github.com/hmhv/MobS)
[![Cocoapods](https://img.shields.io/cocoapods/v/MobS.svg)](https://cocoapods.org/pods/MobS)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)](https://swift.org)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
[![MobS](https://github.com/hmhv/MobS/workflows/MobS/badge.svg)](https://github.com/hmhv/MobS/actions?query=workflow%3AMobS)

## Introduction

MobS is a simple and safe state management library transparently applying functional reactive programming (TFRP) and is inspired by [MobX](https://mobx.js.org/).

## Requirements

- iOS 10.0+
- Swift 5.2+

## Installation

### CocoaPods

```
pod 'MobS'
```

### Swift Package Manager

Open your Xcode project, select File -> Swift Packages -> Add Package Dependency.... and type `https://github.com/hmhv/MobS.git`.


### Manually 

Add the <a href="https://github.com/hmhv/MobS/tree/master/Sources/MobS">MobS</a> folder to your Xcode project to use MobS.</p>

## Usage

[MobSの紹介](https://hmhv.info/2020/05/about-mobs/) | [MobS 소개](https://hmhv.info/2020/05/about-mobs-k/) 

``` swift
class CountUpViewController: UIViewController {

    // ①Create Observable
    @MobS.Observable(value: 0)
    var count: Int

    @IBOutlet weak var countLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ②Create Observer
        addObserver { (self) in
            self.countLabel.text = "\(self.count)"
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        // ③Update Observable
        count += 1
    }

}
```


for more infomation, check [Example project](https://github.com/hmhv/MobS/tree/master/Example).

## License

MobS is released under the MIT license. See [LICENSE](https://github.com/hmhv/MobS/blob/master/LICENSE) for more information.