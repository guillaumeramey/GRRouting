//
//  RouterView.swift
//  RouterBootcamp
//
//  Created by Guillaume Ramey on 04/09/2025.
//

import SwiftUI

public struct RouterView<Content: View>: View, @preconcurrency Router {

    @Environment(\.dismiss) private var _dismiss

    @State private var path: [AnyDestination] = []

    @State private var showSheet: AnyDestination? = nil
    @State private var showFullScreenCover: AnyDestination? = nil

    @State private var modalTransition: AnyTransition?
    @State private var modal: AnyDestination? = nil

    @State private var alert: AnyAppAlert? = nil
    @State private var confirmationDialog: AnyAppAlert? = nil

    // Binding to the view stack from previous RouterViews
    @Binding var screenStack: [AnyDestination]

    var addNavigationView: Bool
    @ViewBuilder var content: (Router) -> Content

    public init(
        screenStack: (Binding<[AnyDestination]>)? = nil,
        addNavigationView: Bool = true,
        content: @escaping (Router) -> Content
    ) {
        self._screenStack = screenStack ?? .constant([])
        self.addNavigationView = addNavigationView
        self.content = content
    }

    public var body: some View {
        NavigationStackIfNeeded(path: $path, addNavigationView: addNavigationView) {
            content(self)
                .sheetViewModifier(screen: $showSheet)
                .fullScreenCoverViewModifier(screen: $showFullScreenCover)
                .showAlert($alert)
                .showConfirmationDialog($confirmationDialog)
        }
        .modalViewModifier(screen: $modal, transition: modalTransition)
        .environment(\.router, self)
    }

    public func push<T: View>(@ViewBuilder destination: @escaping (Router) -> T) {
        showScreen(.push, destination: destination)
    }

    public func sheet<T: View>(@ViewBuilder destination: @escaping (Router) -> T) {
        showScreen(.sheet, destination: destination)
    }

    public func fullScreenCover<T: View>(@ViewBuilder destination: @escaping (Router) -> T) {
        showScreen(.fullScreenCover, destination: destination)
    }

    private func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T) {
        let screen = RouterView<T>(
            screenStack: option.shouldAddNewNavigationView ? nil : (screenStack.isEmpty ? $path : $screenStack),
            addNavigationView: option.shouldAddNewNavigationView
        ) { newRouter in
            destination(newRouter)
        }

        let destination = AnyDestination(destination: screen)

        switch option {
            case .push:
                if screenStack.isEmpty {
                    // This means we are in the first RouterView
                    path.append(destination)
                } else {
                    // This means we are in a secondary RouterView
                    screenStack.append(destination)
                }
            case .sheet:
                showSheet = destination
            case .fullScreenCover:
                showFullScreenCover = destination
        }
    }

    public func dismiss() {
        _dismiss()
    }

    public func showAlert(title: String, subtitle: String? = nil, buttons: (@Sendable () -> AnyView)? = nil) {
        self.alert = AnyAppAlert(title: title, subtitle: subtitle, buttons: buttons)
    }

    public func showConfirmationDialog(title: String, subtitle: String? = nil, buttons: (@Sendable () -> AnyView)? = nil) {
        self.confirmationDialog = AnyAppAlert(title: title, subtitle: subtitle, buttons: buttons)
    }

    public func dismissAlert() {
        alert = nil
        confirmationDialog = nil
    }

    public func modal<T: View>(transition: AnyTransition? = nil, @ViewBuilder destination: @escaping () -> T) {
        self.modalTransition = transition
        modal = AnyDestination(destination: destination())
    }

    public func dismissModal() {
        modal = nil
    }
}
