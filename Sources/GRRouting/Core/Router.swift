//
//  Router.swift
//  RouterBootcamp
//
//  Created by Guillaume Ramey on 04/09/2025.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var router: Router?
}

public protocol Router {
    func push<T: View>(@ViewBuilder destination: @escaping (Router) -> T)
    func sheet<T: View>(@ViewBuilder destination: @escaping (Router) -> T)
    func fullScreenCover<T: View>(@ViewBuilder destination: @escaping (Router) -> T)
    func dismiss()

    func showAlert(title: String, subtitle: String?, buttons: (@Sendable () -> AnyView)?)
    func showConfirmationDialog(title: String, subtitle: String?, buttons: (@Sendable () -> AnyView)?)
    func dismissAlert()

    func modal<T: View>(transition: AnyTransition?, @ViewBuilder destination: @escaping () -> T)
    func dismissModal()
}
