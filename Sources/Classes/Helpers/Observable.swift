import Foundation

class Observable<E> {
    var closures: [UInt: (E) -> Void] = [:]

    func subscribe(_ observer: AnyObject, closure: @escaping (E) -> Void) {
        let key = keyAtObject(observer)
        closures[key] = closure
    }

    func unsubscribe(_ observer: AnyObject) {
        let key = keyAtObject(observer)
        closures.removeValue(forKey: key)
    }

    private func keyAtObject(_ object: AnyObject) -> UInt {
        return UInt(bitPattern: ObjectIdentifier(object))
    }

    func broadcast(_ event: E) {
        for closure in closures.values {
            closure(event)
        }
    }
}
