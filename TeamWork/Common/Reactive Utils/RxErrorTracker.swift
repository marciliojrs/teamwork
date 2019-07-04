import RxSwift
import RxCocoa
import Domain

struct RxErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let subject = ReplaySubject<DomainError>.create(bufferSize: 1)

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, DomainError> {
        return subject.asObservable().asDriver { _ in .empty() }
    }

    func asObservable() -> Observable<DomainError> {
        return subject.asObservable()
    }

    private func onError(_ error: Error) {
        guard let error = error as? DomainError else { return }
        subject.on(.next(error))
    }
}

extension ObservableConvertibleType {
    func track(error errorTracker: RxErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
