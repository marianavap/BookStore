//
//  ErrorHandler.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

import UIKit
import SwiftMessages

struct HandleError {
    
    /// Handle errors
    ///
    /// - Parameter error: the erro
    static func handle(error: Error) {
        
        if let apiError = error as? AllError {
            handleBusiness(error: apiError)
        } else {
            showError()
        }
    }
}

// MARK: - Private
private extension HandleError {
    static func handleBusiness(error: AllError) {
        switch error {
        case .parse(let message):
            print("Parse error - (\(message))")
            showError()
        case .offlineMode:
            showError(title: "You're offline", description: nil)
        case .httpError(let number):
            print("Http error - (\(number))")
            showError()
        case .generic:
            print("Generic error")
            showError()
        }
    }
    
    static func showError(title: String? = "Something went wrong :(", description: String? = "Please, try again later") {
        let view = MessageView.viewFromNib(layout: .messageView)
        
        view.configureContent(title: title,
                              body: description,
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: nil,
                              buttonTitle: "OK",
                              buttonTapHandler: { _ in SwiftMessages.hide() })
        
        view.configureTheme(.error, iconStyle: .light)
        
        var config = SwiftMessages.Config()
        
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.dimMode = .none
        config.preferredStatusBarStyle = .default
        
        SwiftMessages.show(config: config, view: view)
    }
}
