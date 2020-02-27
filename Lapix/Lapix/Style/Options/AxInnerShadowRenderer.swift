//
//  AxInnerShadowRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/23.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit
import CoreUtil

@usableFromInline
internal class AxInnerShadowRenderer {
        
    func drawInnerShadow(_ innerShaodw: SKTInnerShadow, rect:CGRect,  path: CGPath, into context: CGContext) {
        let shadowLayer: CGLayer
        if let cachedLayer:CGLayer = innerShaodw.cache.get(for: .layer) {
            shadowLayer = cachedLayer
        }else{
            guard let newLayer = _createInnerShadowLayer(innerShaodw, size: rect.size, path: path, into: context) else { return }
            innerShaodw.cache.set(newLayer, for: .layer)
            shadowLayer = newLayer
        }
        
        context.draw(shadowLayer, in: rect)
    }
    
    func _createInnerShadowLayer(_ innerShaodw: SKTInnerShadow, size: CGSize, path: CGPath, into context: CGContext) -> CGLayer? {
        guard
            let cgLayer = CGLayer.create(context: context, size: size),
            let context = cgLayer.context
        else { return nil }
        context.setAlpha(innerShaodw.color.alpha)
        
        _drawInnerShadow(innerShaodw, size: size, path: path, into: context)
        
        return cgLayer
    }
    
    func _drawInnerShadow(_ innerShaodw: SKTInnerShadow,size: CGSize, path: CGPath, into context: CGContext) {
        context.saveGState()
        defer {
            context.restoreGState()
            context.resetSetting()
        }
        
        if let contextSettings = innerShaodw.contextSettings { context.applySetting(contextSettings) }
        
        context.addPath(path)
        context.clip()
        
        context.setShadow(offset: .zero, blur: innerShaodw.blurRadius, color: innerShaodw.color.cgColor)
        context.setBlendMode(.multiply)
        context.setFillColor(.white)
        
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        // ============================================================================== //
        
        let rect = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        var tranceform = CGAffineTransform(translationX: innerShaodw.offsetX, y: innerShaodw.offsetY)
        let upath = path.copy(using: &tranceform)!
        let frame = CGPath.subtract(rect, upath)
        
        context.addPath(frame)
        context.fillPath()
        
        if innerShaodw.spread != 0 {
            let borderW = path.copy(strokingWithWidth: innerShaodw.spread * 2, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
            context.addPath(borderW)
            context.fillPath()
        }
        
        context.endTransparencyLayer()
    }
    
}

