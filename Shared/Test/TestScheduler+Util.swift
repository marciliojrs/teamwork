import RxTest
import RxSwift
import RxCocoa

extension TestScheduler {
    /// Creates a `TestableObserver` instance which immediately subscribes
    /// to the `source` and disposes the subscription at virtual time 100000.
    func record<O: ObservableConvertibleType>(_ source: O) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}

public func == (lhs: Never, rhs: Never) -> Bool {
    fatalError()
}
