//
//  ErrorPresentable.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 06..
//

protocol ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel?
}

extension ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel?{
        guard let error = error as? MovieError else{
            return AlertModel(
                title: "alert.unexpected.title".localized(),
                message: "alert.unexpected.text".localized(),
                dismissButtonTitle: "alert.dismiss.button".localized()
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "alert.api.title".localized(),
                message: message,
                dismissButtonTitle: "alert.dismiss.button".localized()
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "alert.dismiss.button".localized()
            )
        case .noInternetError:
            return nil
            
        case .serverError:
            return AlertModel(
                title: "Server Error",
                message: error.localizedDescription,
                dismissButtonTitle: "alert.dismiss.button".localized()
            )
        default:
            return AlertModel(
                title: "alert.unexpected.title".localized(),
                message: "alert.unexpected.text".localized(),
                dismissButtonTitle: "alert.dismiss.button".localized()
            )
        }
    }
}
