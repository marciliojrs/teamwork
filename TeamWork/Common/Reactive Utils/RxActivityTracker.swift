import RxSwift
import RxCocoa

struct RxActivityTracker {

    public typealias Element = Bool

    fileprivate let isLoading = BehaviorRelay(value: false)
    fileprivate let loading: Observable<RxActivityTracker.Element>

    public init() {
        // Observe occurs in main thread
        loading = isLoading.asObservable()
            .skip(1)
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in self.sendStopLoading() },
                onError: { _ in self.sendStopLoading() },
                onCompleted: { self.sendStopLoading() },
                onSubscribe: { self.subscribed() })
    }

    private func subscribed() {
        isLoading.accept(true)
    }

    private func sendStopLoading() {
        isLoading.accept(false)
    }
}

extension RxActivityTracker: ObservableType {
    public func subscribe<O>(_ observer: O) -> Disposable
        where O: ObserverType, RxActivityTracker.Element == O.Element {
        return loading.subscribe(observer)
    }

    public func asObservable() -> Observable<RxActivityTracker.Element> {
        return loading.asObservable()
    }
}

extension ObservableConvertibleType {
    func track(activity activityIndicator: RxActivityTracker) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
