import RxSwift
import RxCocoa

struct RxErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return subject.asObservable().asDriver { _ in .empty() }
    }

    func asObservable() -> Observable<Error> {
        return subject.asObservable()
    }

    private func onError(_ error: Error) {
        subject.on(.next(error))
    }
}

extension ObservableConvertibleType {
    func track(error errorTracker: RxErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
}
