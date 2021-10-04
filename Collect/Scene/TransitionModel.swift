import Foundation

enum TransitionStyle {
    case push
    case root
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
