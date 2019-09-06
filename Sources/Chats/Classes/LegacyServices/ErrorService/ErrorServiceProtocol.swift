import UIKit

public protocol ErrorServiceProtocol: AnyObject {
    var onError: ((ApiError) -> Void)? { get set }
}

protocol InternalErrorService {
    func handleError(_ apiError: ApiError)
}

class ErrorService: ErrorServiceProtocol, InternalErrorService {
    var onError: ((ApiError) -> Void)?
    func handleError(_ apiError: ApiError) {
        onError?(apiError)
    }
}
