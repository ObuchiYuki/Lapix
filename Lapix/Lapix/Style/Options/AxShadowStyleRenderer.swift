//
//  AxShadowStyleRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/23.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit
import Cocoa

@usableFromInline
internal class AxShadowStyleRenderer {
    
    func drawShadow(_ shadow: SKTShadow, rect: CGRect, path: CGPath, into context: CGContext) {
        let shadowLayer: CGLayer
        let shadowSize = _calcShadowSize(size: rect.size, shadow: shadow)
        
        if let cachedLayer: CGLayer = shadow.cache.get(for: .layer) {
            shadowLayer = cachedLayer
        }else{
            guard let newLayer = _createShadowLayer(shadow,shadowSize: shadowSize, size: rect.size, path: path, context: context) else { return }
            shadow.cache.set(newLayer, for: .layer)
            shadowLayer = newLayer
        }
        
        let inset = (shadow.spread + shadow.blurRadius)
        let rect = CGRect(origin: rect.origin + shadow.offset.point - [inset, inset], size: shadowSize)
        context.draw(shadowLayer, in: rect)
    }
    
    /// create shadow layer without offset
    func _createShadowLayer(_ shadow: SKTShadow, shadowSize: CGSize, size: CGSize, path: CGPath, context: CGContext) -> CGLayer? {
        
        let shadowSize = _calcShadowSize(size: size, shadow: shadow)
        guard
            let cgLayer = CGLayer.create(context: context, size: shadowSize),
            let context = cgLayer.context
        else { return  nil }
        
        _drawShadow(shadow, shadowSize: shadowSize, path: path, into: context)
        
        return cgLayer
    }
    
    func _drawShadow(_ shadow: SKTShadow, shadowSize: CGSize, path: CGPath, into context: CGContext) {
        let inset = (shadow.spread + shadow.blurRadius) * NSScreen.scaleFactor
        let offsetY = (shadowSize.height + 100)
        
        var tranceform = CGAffineTransform(translationX: 0, y: -offsetY)
        let path = path.copy(using: &tranceform)!

        context.setShadow(offset: [inset, inset + offsetY * NSScreen.scaleFactor], blur: shadow.blurRadius, color: shadow.color.cgColor)

        /// begin tranceparent layer to use fill and store be one node.
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        /// fill
        context.setFillColor(.black)
        context.addPath(path)
        context.fillPath()

        /// spread
        let spreadMiterLimit:CGFloat = 1000
        context.setStrokeColor(.white)
        context.setMiterLimit(spreadMiterLimit)
        context.setLineWidth(shadow.spread * 2) // consider spread inside -> double
        context.addPath(path)
        context.strokePath()

        context.endTransparencyLayer()
    }
}

func _calcShadowSize(size: CGSize, shadow: SKTShadow) -> CGSize {
    let inset = (shadow.spread + shadow.blurRadius)
    
    return CGSize(width: size.width + inset * 2, height: size.height + inset * 2)
}
