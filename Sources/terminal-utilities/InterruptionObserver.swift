import Foundation

public final class InterruptionObserver {
    private var signalHandler: DispatchSourceSignal?
    private var interruptionHandlers = [() -> Void]()

    private init() {}

    public static func observe() -> InterruptionObserver {
        let observer = InterruptionObserver()
        observer.setupSignalHandler()
        return observer
    }

    public func addInterruptionHandler(_ handler: @escaping () -> Void) {
        interruptionHandlers.append(handler)
    }

    private func setupSignalHandler() {
        let signalHandler = DispatchSource.makeSignalSource(signal: SIGINT)
        signal(SIGINT, SIG_IGN)

        signalHandler.setEventHandler { [weak self] in
            guard let self else { return }
            self.interruptionHandlers.forEach { $0() }
            exit(SIGINT)
        }
        signalHandler.resume()

        self.signalHandler = signalHandler
    }
}
