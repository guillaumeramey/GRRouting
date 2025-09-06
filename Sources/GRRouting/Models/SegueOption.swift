//
//  SegueOption.swift
//  RouterBootcamp
//
//  Created by Guillaume Ramey on 04/09/2025.
//

enum SegueOption {
    case push, sheet, fullScreenCover
    
    var shouldAddNewNavigationView: Bool {
        switch self {
        case .push:
            return false
        case .sheet, .fullScreenCover:
            return true
        }
    }
}
