import XCTest
@testable import MobS

final class ComplexTests: XCTestCase {

    fileprivate var vc: ViewController!

    override func setUp() {
        super.setUp()

        MobS.isTraceEnabled = true
        vc = ViewController()

        XCTAssertEqual(vc.c1Output, "")
        XCTAssertEqual(vc.c2Output, "")
        XCTAssertEqual(vc.c3Output, "")
        XCTAssertEqual(vc.c4Output, "")
        XCTAssertEqual(vc.callCount, 0)
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 4, numberOfComputed: 4)
    }

    func testUpdateO1() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 6, numberOfComputed: 4)

        vc.updateO1()
        XCTAssertEqual(vc.c1Output, "o1 = 1")
        XCTAssertEqual(vc.c2Output, "o2 = 0, o3 = 0")
        XCTAssertEqual(vc.c3Output, "o1 = 1, c1 = o1 = 1")
        XCTAssertEqual(vc.c4Output, "o1 = 1, o3 = 0, c2 = o2 = 0, o3 = 0, c3 = o1 = 1, c1 = o1 = 1")

        vc = nil
        checkMobSZeroInstance()
    }

    func testUpdateO2() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 6, numberOfComputed: 4)

        vc.updateO2()
        XCTAssertEqual(vc.c1Output, "o1 = 0")
        XCTAssertEqual(vc.c2Output, "o2 = 2, o3 = 0")
        XCTAssertEqual(vc.c3Output, "o1 = 0, c1 = o1 = 0")
        XCTAssertEqual(vc.c4Output, "o1 = 0, o3 = 0, c2 = o2 = 2, o3 = 0, c3 = o1 = 0, c1 = o1 = 0")

        vc = nil
        checkMobSZeroInstance()
    }

    func testUpdateO3() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 6, numberOfComputed: 4)

        vc.updateO3()
        XCTAssertEqual(vc.c1Output, "o1 = 0")
        XCTAssertEqual(vc.c2Output, "o2 = 0, o3 = 3")
        XCTAssertEqual(vc.c3Output, "o1 = 0, c1 = o1 = 0")
        XCTAssertEqual(vc.c4Output, "o1 = 0, o3 = 3, c2 = o2 = 0, o3 = 3, c3 = o1 = 0, c1 = o1 = 0")

        vc = nil
        checkMobSZeroInstance()
    }

    func testUpdateAll() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 6, numberOfComputed: 4)

        vc.updateAll()
        XCTAssertEqual(vc.c1Output, "o1 = 1")
        XCTAssertEqual(vc.c2Output, "o2 = 2, o3 = 3")
        XCTAssertEqual(vc.c3Output, "o1 = 1, c1 = o1 = 1")
        XCTAssertEqual(vc.c4Output, "o1 = 1, o3 = 3, c2 = o2 = 2, o3 = 3, c3 = o1 = 1, c1 = o1 = 1")

        vc = nil
        checkMobSZeroInstance()
    }

    func testMutipleUpdate() {
        vc.setupForUpdate()
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 6, numberOfComputed: 4)

        vc.updateO1()
        vc.updateO2()
        vc.updateO3()
        XCTAssertEqual(vc.c1Output, "o1 = 1")
        XCTAssertEqual(vc.c2Output, "o2 = 2, o3 = 3")
        XCTAssertEqual(vc.c3Output, "o1 = 1, c1 = o1 = 1")
        XCTAssertEqual(vc.c4Output, "o1 = 1, o3 = 3, c2 = o2 = 2, o3 = 3, c3 = o1 = 1, c1 = o1 = 1")

        vc = nil
        checkMobSZeroInstance()
    }

    func testCallCount() {
        vc.setupForCallCount()
        XCTAssertEqual(vc.callCount, 1)
        checkMobSInstanceCount(numberOfObservable: 3, numberOfObserver: 5, numberOfComputed: 4)

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
    var o1: Int

    @MobS.Observable(value: 0)
    var o2: Int

    @MobS.Observable(value: 0)
    var o3: Int

    @MobS.Computed
    var c1: String

    @MobS.Computed
    var c2: String

    @MobS.Computed
    var c3: String

    @MobS.Computed
    var c4: String

    init() {
        $c1.initComputed(with: self) { (self) in
            "o1 = \(self.o1)"
        }
        $c2.initComputed(with: self) { (self) in
            "o2 = \(self.o2), o3 = \(self.o3)"
        }
        $c3.initComputed(with: self) { (self) in
            "o1 = \(self.o1), c1 = \(self.c1)"
        }
        $c4.initComputed(with: self) { (self) in
            "o1 = \(self.o1), o3 = \(self.o3), c2 = \(self.c2), c3 = \(self.c3)"
        }
    }

}

fileprivate class ViewController: RemoverOwner {

    let viewModel = ViewModel()

    var c1Output = ""
    var c2Output = ""
    var c3Output = ""
    var c4Output = ""

    var callCount = 0

    func setupForUpdate() {
        addObserver { (self) in
            self.c1Output = self.viewModel.c1
            self.c2Output = self.viewModel.c2
        }
        addObserver { (self) in
            self.c3Output = self.viewModel.c3
            self.c4Output = self.viewModel.c4
        }
    }

    func setupForCallCount() {
        addObserver { (self) in
            self.c1Output = self.viewModel.c1
            self.c2Output = self.viewModel.c2
            self.c3Output = self.viewModel.c3
            self.c4Output = self.viewModel.c4

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
