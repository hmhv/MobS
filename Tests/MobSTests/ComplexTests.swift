import XCTest
@testable import MobS

final class ComplexTests: XCTestCase {

    fileprivate var vc: ViewController!

    override func setUp() {
        super.setUp()

        MobS.isTraceEnabled = true
        vc = ViewController()

        XCTAssertEqual(vc.o1Output, 0)
        XCTAssertEqual(vc.o2Output, 0)
        XCTAssertEqual(vc.o3Output, 0)
        XCTAssertEqual(vc.callCount, 0)
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 2)
    }

    func testUpdateO1() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 3)

        vc.updateO1()
        XCTAssertEqual(vc.o1Output, 1)
        XCTAssertEqual(vc.o2Output, 1)
        XCTAssertEqual(vc.o3Output, 1)

        vc = nil
        checkMobSZeroInstance()
    }

    func testUpdateO2() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 3)

        vc.updateO2()
        XCTAssertEqual(vc.o1Output, 0)
        XCTAssertEqual(vc.o2Output, 2)
        XCTAssertEqual(vc.o3Output, 2)

        vc = nil
        checkMobSZeroInstance()
    }

    func testUpdateO3() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 3)

        vc.updateO3()
        XCTAssertEqual(vc.o1Output, 0)
        XCTAssertEqual(vc.o2Output, 0)
        XCTAssertEqual(vc.o3Output, 3)

        vc = nil
        checkMobSZeroInstance()
    }

    func testUpdateAll() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 3)

        vc.updateAll()
        XCTAssertEqual(vc.o1Output, 1)
        XCTAssertEqual(vc.o2Output, 1)
        XCTAssertEqual(vc.o3Output, 1)

        vc = nil
        checkMobSZeroInstance()
    }

    func testMutipleUpdate() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 3)

        vc.updateO1()
        vc.updateO2()
        vc.updateO3()
        XCTAssertEqual(vc.o1Output, 1)
        XCTAssertEqual(vc.o2Output, 2)
        XCTAssertEqual(vc.o3Output, 3)

        vc = nil
        checkMobSZeroInstance()
    }

    func testCallCount() {
        vc.setupForCallCount()
        XCTAssertEqual(vc.callCount, 1)
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 3)

        vc.updateO1()
        XCTAssertEqual(vc.callCount, 2)

        vc.updateO2()
        XCTAssertEqual(vc.callCount, 3)

        vc.updateO3()
        XCTAssertEqual(vc.callCount, 4)

        vc.updateAll()
        XCTAssertEqual(vc.callCount, 5)

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

fileprivate class ViewModel: RemoverOwner {

    @MobS.Observable(value: 0)
    var o1: Int

    @MobS.Observable(value: 0)
    var o2: Int

    @MobS.Observable(value: 0)
    var o3: Int

    init() {
        $o1.addObserver(with: self) { (self, o1) in
            self.o2 = o1
        }
        $o2.addObserver(with: self) { (self, o2) in
            self.o3 = o2
        }
    }

}

fileprivate class ViewController: RemoverOwner {

    let viewModel = ViewModel()

    var o1Output = 0
    var o2Output = 0
    var o3Output = 0

    var callCount = 0

    func setupForUpdate() {
        addObserver { (self) in
            self.o1Output = self.viewModel.o1
            self.o2Output = self.viewModel.o2
            self.o3Output = self.viewModel.o3
        }
    }

    func setupForCallCount() {
        addObserver { (self) in
            self.o1Output = self.viewModel.o1
            self.o2Output = self.viewModel.o2
            self.o3Output = self.viewModel.o3

            self.callCount += 1
        }
    }

    func updateO1() {
        viewModel.o1 = 1
    }

    func updateO2() {
        viewModel.o2 = 2
    }

    func updateO3() {
        viewModel.o3 = 3
    }

    func updateAll() {
        MobS.updateState {
            viewModel.o1 = 1
            viewModel.o2 = 2
            viewModel.o3 = 3
        }
    }

}
