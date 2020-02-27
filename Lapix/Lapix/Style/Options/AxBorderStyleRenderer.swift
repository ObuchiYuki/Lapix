//
//  AxBorderStyleRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/23.
//  Copyright © 2020 yuki. All rights reserved.
//

import Cocoa
import SketchKit

internal class AxBorderStyleRenderer {
    
    private let gradientRenderer = AxStyleGradientRenderer()
    
    func drawBorder(_ border: SKTBorder, borderOptions: SKTBorderOptions?, rect: CGRect, path: CGPath, into context: CGContext) {
        
        let borderSize = _calcBorderSize(border: border, size: rect.size)
        
        let borderLayer: CGLayer
        if let cachedLayer:CGLayer = border.cache.get(for: .layer) {
            borderLayer = cachedLayer
        }else{
            guard
                let newLayer = _createLayer(border, borderOptions: borderOptions, borderSize: borderSize, size: rect.size, path: path, context: context)
                else { return }
            
            border.cache.set(newLayer, for: .layer)
            borderLayer = newLayer
        }
        
        let rect = CGRect(origin: rect.origin + _calcBorderOrigin(border: border), size: borderSize)
        context.draw(borderLayer, in: rect)
    }
    
    private func _createLayer(_ border: SKTBorder, borderOptions: SKTBorderOptions?, borderSize: CGSize, size: CGSize, path: CGPath, context: CGContext) -> CGLayer?{
        guard
            let cgLayer = CGLayer.create(context: context, size: borderSize),
            let context = cgLayer.context
            else { return nil }
        
        self._drawBorder(border, borderOptions: borderOptions, size: size, path: path, into: context)
        
        return cgLayer
    }
    
    func _drawBorder(_ border: SKTBorder, borderOptions: SKTBorderOptions?, size: CGSize, path: CGPath, into context: CGContext) {
        if let contextSetting = border.contextSettings { context.applySetting(contextSetting) }
        
        defer {
            context.resetSetting()
        }
        
        let borderPath = _createBorderPath(border, borderOptions: borderOptions, path: path, context: context)
        
        switch border.fillType {
            case .color:
                guard let color = border.color else {
                    assertionFailure("A nil color for color fill.")
                    return
                }
                _drawBorder(with: color, borderPath: borderPath, into: context)
            case .gradient:
                guard let gradient = border.gradient else {
                    assertionFailure("A nil gradient for gradient fill.")
                    return
                }
                _drawBorder(with: gradient, size: size, borderPath: borderPath, into: context)
            
            case .image:
                assertionFailure("Image fill for border is not allowed. (If sketch allows image border, let me know...)")
                return
        }
    }
    
    
    @usableFromInline
    internal func _drawBorder(with gradient: SKTGradient, size: CGSize, borderPath: CGPath, into context: CGContext) {
        gradientRenderer.drawGradient(gradient, size: size, path: borderPath, into: context)
    }
    
    @usableFromInline
    internal func _drawBorder(with color: SKTColor, borderPath: CGPath, into context: CGContext) {
        context.setFillColor(color.cgColor)
        context.addPath(borderPath)
        context.fillPath()
    }
}



private func _createBorderPath(_ border: SKTBorder, borderOptions: SKTBorderOptions?, path: CGPath, context: CGContext) -> CGPath {
    let lineCap = borderOptions?.lineCapStyle ?? CGLineCap.butt
    let lineJoin = borderOptions?.lineJoinStyle ?? CGLineJoin.miter
    let thickness = border.thickness
    var tranceform = CGAffineTransform(translationX: thickness, y: thickness)
    
    switch border.position {
        case .center:
            return path
                .copy(strokingWithWidth: thickness, lineCap: lineCap, lineJoin: lineJoin, miterLimit: 20)
                .copy(using: &tranceform)!
        case .outside:
            
            
            let borderW = path.copy(strokingWithWidth: thickness * 2, lineCap: lineCap, lineJoin: lineJoin, miterLimit: 20)
            let borderPath = CGPath.subtract(borderW, path)
            return borderPath
                .copy(using: &tranceform)!
        case .inside:
            let borderW = path.copy(strokingWithWidth: thickness * 2, lineCap: lineCap, lineJoin: lineJoin, miterLimit: 20)
            context.addPath(path)
            context.clip()
            context.addPath(borderW)
            
            return context.path!
                .copy(using: &tranceform)!
    }
}

private func _calcBorderOrigin(border: SKTBorder) -> CGPoint {
    CGPoint(x: -border.thickness, y: -border.thickness)
}
private func _calcBorderSize(border: SKTBorder, size: CGSize) -> CGSize {
    let thickness = border.thickness * NSScreen.scaleFactor
    return CGSize(width: size.width + thickness * 2, height: size.height + thickness * 2)
}
