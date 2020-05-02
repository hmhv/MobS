import XCTest
@testable import MobS

final class ObservableTests: XCTestCase {

    fileprivate var vc: ViewController!

    override func setUp() {
        super.setUp()
        MobS.isTraceEnabled = true
        vc = ViewController()
    }

    func checkMobSZeroInstance() {
        checkMobSInstanceCount(numberOfObservable: 0, numberOfObserver: 0, numberOfComputed: 0)
    }

    func checkMobSInstanceCount(numberOfObservable: Int, numberOfObserver: Int, numberOfComputed: Int) {
        XCTAssertEqual(MobS.numberOfObservable, numberOfObservable)
        XCTAssertEqual(MobS.numberOfObserver, numberOfObserver)
        XCTAssertEqual(MobS.numberOfComputed, numberOfComputed)
    }

    func testMobSAddObserver() {
        vc.setupForMobSAddObserver()
        XCTAssertEqual(vc.scoreOutput, 0)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1, numberOfComputed: 0)
        vc = nil
        checkMobSZeroInstance()
    }

    func testNSObjectAddObserver() {
        vc.setupForNSObjectAddObserver()
        XCTAssertEqual(vc.scoreOutput, 0)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1, numberOfComputed: 0)
        vc = nil
        checkMobSZeroInstance()
    }

    func testObservableAddObserver() {
        vc.setupForObservableAddObserver()
        XCTAssertEqual(vc.scoreOutput, 0)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1, numberOfComputed: 0)
        vc = nil
        checkMobSZeroInstance()
    }

    func testObservableBind() {
        vc.setupForObservableBind()
        XCTAssertEqual(vc.scoreOutput, 0)

        vc.updateScore()
        XCTAssertEqual(vc.scoreOutput, ViewController.scoreResult)

        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1, numberOfComputed: 0)
        vc = nil
        checkMobSZeroInstance()
    }

    func testObservableBindTransform() {
        vc.setupForObservableBindTransform()
        XCTAssertEqual(vc.scoreOutput, 0)

        vc.updateScore()
        XCTAssertEqual(vc.scoreStringOutput, ViewController.scoreStringResult)

        checkMobSInstanceCount(numberOfObservable: 1, numberOfObserver: 1, numberOfComputed: 0)
        vc = nil
        checkMobSZeroInstance()
    }

}

fileprivate class ViewModel {

    @MobS.Observable(value: 0)
    var score: Int

}

fileprivate class ViewController: RemoverOwner {

    static let scoreResult = 3
    static let scoreStringResult = "3"

    let viewModel = ViewModel()

    var scoreOutput = 0
    var scoreStringOutput = ""

    func setupForMobSAddObserver() {
        MobS.addObserver { [weak self] in
            guard let self = self else { return }
            self.scoreOutput = self.viewModel.score
        }.removed(by: remover)
    }

    func setupForNSObjectAddObserver() {
        addObserver { (self) in
            self.scoreOutput = self.viewModel.score
        }
    }

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
