import UIKit

public protocol ErrorService: AnyObject {
    var onError: ((ApiError) -> Void)? { get set }
}

protocol InternalErrorService {
    func handleError(_ apiError: ApiError)
}

class ErrorServiceImpl: ErrorService, InternalErrorService {
    var onError: ((ApiError) -> Void)?
    func handleError(_ apiError: ApiError) {
        onError?(apiError)
    }
}
