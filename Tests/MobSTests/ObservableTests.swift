import XCTest
@testable import MobS

final class ObservableTests: XCTestCase {

    fileprivate var vc: ViewController!

    override func setUp() {
        super.setUp()

        MobS.isTraceEnabled = true
        vc = ViewController()

        XCTAssertEqual(vc.scoreOutput, 0)
        XCTAssertEqual(vc.scoreStringOutput, "")
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 0)
    }

    func testObservableAddObserver() {
        vc.setupForObservableAddObserver()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func testObservableBind() {
        vc.setupForObservableBind()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func testObservableBindTransform() {
        vc.setupForObservableBindTransform()
        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1)

        vc.updateScore()
        XCTAssertEqual(vc.scoreStringOutput, ViewController.scoreStringResult)

        vc = nil
        checkMobSZeroInstance()
    }

    func checkMobSZeroInstance() {
        checkMobSInstanceCount(numberOfObservable: 0, numberOfObserver: 0)
    }

    func checkMobSInstanceCount(numberOfObservable: Int, numberOfObserver: Int) {
        XCTAssertEqual(MobS.numberOfObservable, numberOfObservable)
        XCTAssertEqual(MobS.numberOfObserver, numberOfObserver)
    }

}

fileprivate class ViewModel {

    @MobS.Observable(value: 0)
    var score: Int

}

fileprivate class ViewController: MobSRemoverOwner {

    static let scoreResult = 3
    static let scoreStringResult = "3"

    let viewModel = ViewModel()

    var scoreOutput = 0
    var scoreStringOutput = ""

    func setupForObservableAddObserver() {
        viewModel.$score.addObserver(with: self) { (self, score) in
            self.scoreOutput = score
        }
    }

    func setupForObservableBind() {
        viewModel.$score.bind(to: self, keyPath: \.scoreOutput)
    }

    func setupForObservableBindTransform() {
        viewModel.$score.bind(to: self, keyPath: \.scoreStringOutput) { (score) in
            "\(score)"
        }
    }

    func updateScore() {
        viewModel.score = ViewController.scoreResult
    }

}
