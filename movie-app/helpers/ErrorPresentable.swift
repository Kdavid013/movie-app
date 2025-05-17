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
                title: "alert.unexpected.title",
                message: "alert.unexpected.text",
                dismissButtonTitle: "alert.dismiss.button"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "alert.api.title",
                message: message,
                dismissButtonTitle: "alert.dismiss.button"
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "alert.dismiss.button"
            )
        case .noInternetError:
            return nil
        default:
            return AlertModel(
                title: "alert.unexpected.title",
                message: "alert.unexpected.text",
                dismissButtonTitle: "alert.dismiss.button"
            )
        }
    }
}
