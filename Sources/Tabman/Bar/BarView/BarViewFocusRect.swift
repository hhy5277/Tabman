//
//  BarViewFocusRect.swift
//  Tabman
//
//  Created by Merrick Sapsford on 04/09/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

/// Rect struct similar to CGRect that provides ability to take factors such as capacity and position into account.
internal struct BarViewFocusRect {
    
    // MARK: Properties
    
    private let rect: CGRect
    private let position: CGFloat
    private let capacity: CGFloat
    
    /// Origin of the original rect.
    var origin: CGPoint {
        return rect.origin
    }
    /// Size of the original rect.
    var size: CGSize {
        return rect.size
    }
    
    // MARK: Init
    
    /// Create a FocusRect with an original CGRect at a position.
    ///
    /// - Parameters:
    ///   - rect: The original rect.
    ///   - position: The current page position.
    ///   - capacity: The capacity to use.
    init(rect: CGRect, at position: CGFloat, capacity: Int) {
        self.rect = rect
        self.position = position
        self.capacity = CGFloat(capacity - 1) // Rect capacity is actually zero indexed
    }
    
    /// Get the rect of the FocusRect accounting for additional factors.
    ///
    /// - Parameter includeOverscroll: Whether to include overscrolling if relevant.
    /// - Returns: Rect with additional factors accounted for.
    func rect(isProgressive: Bool, includeOverscroll: Bool) -> CGRect {
        switch isProgressive {
        case true:
            return progressiveRect(withOverscroll: includeOverscroll, for: rect)
            
        case false:
            return rect(withOverscroll: includeOverscroll, for: rect)
        }
    }
}

private extension BarViewFocusRect {
    
    func rect(withOverscroll: Bool, for rect: CGRect) -> CGRect {
        guard withOverscroll else {
            return rect
        }
        
        if position < 0.0 {
            return rect.offsetBy(dx: rect.width * position, dy: 0.0)
        } else if position > capacity {
            let delta = position - capacity
            return rect.offsetBy(dx: rect.width * delta, dy: 0.0)
        }
        return rect
    }
    
    func progressiveRect(withOverscroll: Bool, for rect: CGRect) -> CGRect {
        var rect = rect
        
        rect.size.width += rect.origin.x
        rect.origin.x = 0.0
        
        if position < 0.0 {
            rect.size.width += rect.width * position
        } else if position > capacity {
            let delta = position - capacity
            return rect.offsetBy(dx: rect.width * delta, dy: 0.0)
        }
        
        return rect
    }
}