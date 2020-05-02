import XCTest
@testable import MobS

final class ComputedTests: XCTestCase {

    fileprivate var vc: ViewController!

    override func setUp() {
        super.setUp()

        MobS.isTraceEnabled = true
        vc = ViewController()

        XCTAssertEqual(vc.scoreOutput, 0)
        XCTAssertEqual(vc.scoreStringOutput, "")
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 0, numberOfComputed: 1)
    }

    func testInitComputed() {
        vc.setupForInitComputed()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 2, numberOfComputed: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreStringOutput, ViewController.scoreStringResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func testInitComputedWithOwner() {
        vc.setupForInitComputedWithOwner()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 2, numberOfComputed: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreStringOutput, ViewController.scoreStringResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func testComputedAddObserver() {
        vc.setupForComputedAddObserver()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 2, numberOfComputed: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreStringOutput, ViewController.scoreStringResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func testComputedBind() {
        vc.setupForComputedBind()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 2, numberOfComputed: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreStringOutput, ViewController.scoreStringResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func testComputedBindTransform() {
        vc.setupForComputedBindTransform()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 2, numberOfComputed: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func checkMobSZeroInstance() {
        checkMobSInstanceCount(numberOfObservable: 0, numberOfObserver: 0, numberOfComputed: 0)
    }

    func checkMobSInstanceCount(numberOfObservable: Int, numberOfObserver: Int, numberOfComputed: Int) {
        XCTAssertEqual(MobS.numberOfObservable, numberOfObservable)
        XCTAssertEqual(MobS.numberOfObserver, numberOfObserver)
        XCTAssertEqual(MobS.numberOfComputed, numberOfComputed)
    }

}

fileprivate class ViewModel {

    @MobS.Observable(value: 0)
    var score: Int

    @MobS.Computed
    var scoreString: String

    func initComputed() {
        $scoreString.initComputed { [weak self] in
            guard let self = self else { return "" }
            return "Current Score is \(self.score)"
        }
    }

    func initComputedWithOwner() {
        $scoreString.initComputed(with: self) { (self) in
            "Current Score is \(self.score)"
        }
    }

}

fileprivate class ViewController: RemoverOwner {

    static let scoreResult = 3
    static let scoreStringResult = "Current Score is 3"

    let viewModel = ViewModel()

    var scoreOutput = 0
    var scoreStringOutput = ""

    func setupForInitComputed() {
        viewModel.initComputed()
        MobS.addObserver { [weak self] in
            guard let self = self else { return }
            self.scoreStringOutput = self.viewModel.scoreString
        }.removed(by: remover)
    }

    func setupForInitComputedWithOwner() {
        viewModel.initComputedWithOwner()
        MobS.addObserver { [weak self] in
            guard let self = self else { return }
            self.scoreStringOutput = self.viewModel.scoreString
        }.removed(by: remover)
    }

    func setupForComputedAddObserver() {
        viewModel.initComputed()
        viewModel.$scoreString.addObserver(with: self) { (self, scoreString) in
            self.scoreStringOutput = scoreString
        }
    }

    func setupForComputedBind() {
        viewModel.initComputedWithOwner()
        viewModel.$scoreString.bind(to: self, keyPath: \.scoreStringOutput)
    }

    func setupForComputedBindTransform() {
        viewModel.initComputedWithOwner()
        viewModel.$scoreString.bind(to: self, keyPath: \.scoreOutput) { (scoreString) in
            Int(scoreString.replacingOccurrences(of: "Current Score is ", with: ""))!
        }
    }

    func updateScore() {
        viewModel.score = ViewController.scoreResult
    }

}
