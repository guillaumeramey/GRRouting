//
//  AlertViewModifier.swift
//  RouterBootcamp
//
//  Created by Guillaume Ramey on 04/09/2025.
//

import SwiftUI

extension View {

    @ViewBuilder
    func showAlert(_ alert: Binding<AnyAppAlert?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "", isPresented: Binding(ifNotNil: alert)) {
                alert.wrappedValue?.buttons()
            } message: {
                if let subtitle = alert.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            }
    }

    @ViewBuilder
    func showConfirmationDialog(_ alert: Binding<AnyAppAlert?>) -> some View {
        self
            .confirmationDialog(alert.wrappedValue?.title ?? "", isPresented: Binding(ifNotNil: alert)) {
                alert.wrappedValue?.buttons()
            } message: {
                if let subtitle = alert.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            }
    }
}
