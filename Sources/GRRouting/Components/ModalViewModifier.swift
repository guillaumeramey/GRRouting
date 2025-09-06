//
//  ModalViewModifier.swift
//  RouterBootcamp
//
//  Created by Guillaume Ramey on 04/09/2025.
//

import SwiftUI

struct ModalViewBuilder<Content: View>: View {

    @Binding var isPresented: Bool
    let transition: AnyTransition?
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.smooth))
                    .onTapGesture {
                        isPresented = false
                    }
                    .zIndex(1)

                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .transition(transition ?? .opacity)
                    .zIndex(2)
            }
        }
        .animation(.bouncy, value: isPresented)
    }
}

extension View {
    func modalViewModifier(screen: Binding<AnyDestination?>, transition: AnyTransition? = nil) -> some View {
        self
            .overlay {
                ModalViewBuilder(isPresented: Binding(ifNotNil: screen), transition: transition) {
                    ZStack {
                        if let screen = screen.wrappedValue {
                            screen.destination
                        }
                    }
                }
            }
    }
}
