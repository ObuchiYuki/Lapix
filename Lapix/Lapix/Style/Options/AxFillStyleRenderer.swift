 //
 //  AxFillStyleRenderer.swift
 //  AxRenderCoreSample
 //
 //  Created by yuki on 2020/01/23.
 //  Copyright © 2020 yuki. All rights reserved.
 //
 
 import Cocoa
 import SketchKit
 import CoreUtil
 
 
 
 // ======================================================================================== //
 // AxFillStyleRenderer
 @usableFromInline
 internal class AxFillStyleRenderer {
    private let gradientRenderer = AxStyleGradientRenderer()
    
    // ======================================================================================== //
    // Method
    @usableFromInline internal func drawFill(_ fill: SKTFill, rect: CGRect, path: CGPath, into context: CGContext) {
        let fillLayer: CGLayer
        
        if let cachedLayer:CGLayer = fill.cache.get(for: .layer) {
            fillLayer = cachedLayer
        }else{
            guard let newLayer = _createsFillLayer(fill, size: rect.size, path: path, context: context) else { return }
            
            fill.cache.set(newLayer, for: .layer)
            fillLayer = newLayer
        }
        
        context.draw(fillLayer, in: rect)
    }
    
    internal func _createsFillLayer(_ fill: SKTFill, size: CGSize, path: CGPath, context: CGContext) -> CGLayer? {
        guard
            let cgLayer = CGLayer.create(context: context, size: size),
            let context = cgLayer.context
            else { return nil }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
        
        self._drawFill(fill, size: size, path: path, into: context)
        
        NSGraphicsContext.restoreGraphicsState()
        return cgLayer
    }
    
    func _drawFill(_ fill: SKTFill, size: CGSize, path: CGPath, into context: CGContext) {
        if let contextSettings = fill.contextSettings { context.applySetting(contextSettings) }
        defer {
            context.resetSetting()
        }
        
        switch fill.fillType {
            case .color:
                guard let color = fill.color else {
                    assertionFailure("A nil color for color fill.")
                    return
                }
                _drawColor(color, path: path, into: context)
            case .gradient:
                guard let gradient = fill.gradient else {
                    assertionFailure("A nil gradient for gradient fill.")
                    return
                }
                _drawGradient(gradient, size: size, path: path, into: context)
            
            case .image:
                guard let imageData = fill.image?.data, let image = NSImage(data: imageData as Data) else { return }
                image.draw(in: CGRect(origin: .zero, size: size))
                
                return
        }
    }
    
    @usableFromInline internal func _drawColor(_ color: SKTColor, path: CGPath, into context: CGContext) {
        context.addPath(path)
        context.setFillColor(color.cgColor)
        context.fillPath(using: .evenOdd)
    }
    
    @usableFromInline internal func _drawGradient(_ gradient: SKTGradient, size: CGSize, path: CGPath, into context: CGContext) {
        context.addPath(path)
        context.clip()
        gradientRenderer.drawGradient(gradient, size: size, path: path, into: context)
        context.resetClip()
    }
 }
