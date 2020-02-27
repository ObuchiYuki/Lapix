//
//  AxStyleGradientGenerator.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/23.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit
import Cocoa
import CoreUtil

// ======================================================================================== //
// MARK: -AxStyleGradientRenderer  -
internal class AxStyleGradientRenderer {
    
    // MARK: - Draw -
    /// ZEROに焼く
    internal func drawGradient(_ gradient: SKTGradient, size: CGSize, path: CGPath, into context: CGContext)  {
        guard gradient.gradientType != .conic else { return print("conic gradient is not supported.") }
        
        // Clipping
        context.addPath(path)
        context.clip()
        
        // Create Layer
        let gradientLayer: CALayer
        
        if let cachedLayer:CALayer = gradient.cache.get(for: .layer) {
            gradientLayer = cachedLayer
        }else {
            gradientLayer = _createGradientLayer(gradient: gradient, size: size)
            gradient.cache.set(gradientLayer, for: .layer) 
        }
        
        // Create Layer
        gradientLayer.render(in: context)
        context.resetClip()
    }
}

// ======================================================================================== //

private func _createGradientLayer(gradient: SKTGradient, size: CGSize) -> CALayer {
    let colors:[Any] = gradient.stops.map{ $0.color.cgColor }
    let locations:[NSNumber] = gradient.stops.map{ $0.position as NSNumber }
    
    let gradientLayer = CAGradientLayer()
    
    do {
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = gradient.from
        gradientLayer.endPoint = gradient.to
        gradientLayer.frame.size = size
        
        switch gradient.gradientType ?? .axial {
            case .axial:
                gradientLayer.type = .axial
            case .radial:
                // TODO: - 特殊なradialに対応 -
                gradientLayer.type = .radial
            case .conic:
                assertionFailure("Conic layer can't render in ordinal way.")
        }
    }
    
    return gradientLayer
}
