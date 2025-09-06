//
//  AnyDestination.swift
//  RouterBootcamp
//
//  Created by Guillaume Ramey on 04/09/2025.
//

import SwiftUI

public struct AnyDestination: Hashable, @unchecked Sendable {
    let id = UUID().uuidString
    var destination: AnyView

    public init<T: View>(destination: T) {
        self.destination = AnyView(destination)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: AnyDestination, rhs: AnyDestination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
