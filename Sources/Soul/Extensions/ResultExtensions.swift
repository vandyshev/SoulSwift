import Foundation

extension Result where Success == SoulResponse, Failure == SoulSwiftError {
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess?) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let response):
            if let newSuccess = transform(response) {
                return .success(newSuccess)
            } else {
                return .failure(SoulSwiftError.decoderError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    func map<NewSuccess1, NewSuccess2>(_ transform: (Success) -> (NewSuccess1?, NewSuccess2?)) -> Result<(NewSuccess1, NewSuccess2), Failure> {
        switch self {
        case .success(let response):
            if let newSuccess0 = transform(response).0, let newSuccess1 = transform(response).1 {
                return .success((newSuccess0, newSuccess1))
            } else {
                return .failure(SoulSwiftError.decoderError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
