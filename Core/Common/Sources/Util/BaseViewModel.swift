//
//  BaseViewModel.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

@MainActor
open class BaseViewModel {
    
    public init() {}
    
    public func handleError(_ error: Error) -> CinelexError {
        if let apiError = error as? CinelexApiError {
            let resolvedError = apiError.value()
            CinelexLogger.debug("code: \(resolvedError.code) message: \(resolvedError.description)")
            return resolvedError
        } else {
            CinelexLogger.debug("message: \(error.localizedDescription)")
            return CinelexError(
                code: ErrorConstant.unknownError,
                description: "Something went wrong"
            )
        }
    }
}
