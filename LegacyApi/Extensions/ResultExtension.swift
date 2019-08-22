import Moya
import Result

extension Result where Value: Response {
    func map<D: Decodable>(_ type: D.Type) -> Swift.Result<D, SoulSwiftError> {
        switch self {
        case .success(let moyaResponse):
            do {
                let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                let decodable: D = try filteredResponse.map(D.self)
                return .success(decodable)
            } catch MoyaError.statusCode(let moyaResponse) {
                return .failure(mapErrorResponse(moyaResponse))
            } catch let error as MoyaError {
                return .failure(SoulSwiftError.moyaError(error))
            } catch let error {
                return .failure(SoulSwiftError.underlying(error))
            }
        case .failure(let error):
            do {
                throw error
            } catch let error as MoyaError {
                return .failure(SoulSwiftError.moyaError(error))
            } catch let error {
                return .failure(SoulSwiftError.underlying(error))
            }
        }
    }

    private func mapErrorResponse(_ moyaResponse: Response) -> SoulSwiftError {
        do {
            let error = try moyaResponse.map(SoulApiError.self, atKeyPath: "error")
            return SoulSwiftError.apiError(error)
        } catch let moyaError as MoyaError {
            return SoulSwiftError.moyaError(moyaError)
        } catch let error {
            return SoulSwiftError.underlying(error)
        }
    }
}
