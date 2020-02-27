//
//  AxLayerNodeRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/22.
//  Copyright © 2020 yuki. All rights reserved.
//

import Cocoa
import SketchKit
import CoreUtil
import CoreGraphics
import QuartzCore

// ========================================================================================== //
// MARK: - AxLayerNodeRenderer -
internal class AxLayerNodeRenderer {

    // ========================================================================================== //
    // MARK: - Properties -
    public static let shared = AxLayerNodeRenderer()
    
    // MARK: - Renderers -
    private let shapeNodeRenderer = AxShapeNodeRenderer()
    private let textRenderer = AxTextRenderer()
    private let bitmapRenderer = AxBitmapRenderer()
        
    // ========================================================================================== //
    // MARK: - Methods -
    
    /// artboardをrect内に描画します。
    public func drawArtboard(_ artboard: SKTArtboard, origin: CGPoint = .zero) {
        
        let path = NSBezierPath(rect: CGRect(origin: origin, size: artboard.frame.size))
        path.setClip()
        
        NSGraphicsContext.saveGraphicsState()
        let shadow = NSShadow()
        shadow.shadowColor = .black
        shadow.shadowOffset = [0, 3]
        shadow.shadowBlurRadius = 5
        //shadow.set()
        let fillColor: NSColor
        if artboard.hasBackgroundColor {
            fillColor = artboard.backgroundColor.nsColor
        }else{
            fillColor = .white
        }
        fillColor.setFill()
        path.fill()
        NSGraphicsContext.restoreGraphicsState()
            
        for layer in artboard.layers {
            self.drawNode(node: layer, origin: origin)
        }
    }
    
    private let pathGenerator = AxPathGenerator()
    
    internal func drawNode(node: SKTLayerNode, origin: CGPoint = .zero){
        
        if let shapeNode = node as? SKTShapeNode {
            let path = pathGenerator.generateShapeNodePath(shapeNode)
            
            if node.hasClippingMask ?? false {
                _enableMask(with: path, origin: origin)
            }
            
            shapeNodeRenderer.drawShapeNode(shapeNode, origin: origin, path: path) ; return
        }
        if let text = node as? SKTText {
            textRenderer.drawText(text, origin: origin) ; return
        }
        if let bitmap = node as? SKTBitmap {
            bitmapRenderer.drawBitmap(bitmap, origin: origin) ; return
        }
        
        if let shapeGroup = node as? SKTShapeGroup {
            let path = pathGenerator.generateShapeGroupPath(shapeGroup)
            
            if node.hasClippingMask ?? false {
                _enableMask(with: path, origin: origin)
            }
            
            shapeNodeRenderer.drawShapeGroup(shapeGroup, origin: origin, path: path) ; return
        }
        if let group = node as? SKTGroup {
            for layer in group.layers {
                self.drawNode(node: layer, origin: origin + group.frame.origin)
            }
            _disableMask()
            return
        }
        
        
    }
    
    private func _enableMask(with path: CGPath, origin: CGPoint) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        var tranceform = CGAffineTransform(translationX: origin.x, y: origin.y)
        context.addPath(path.copy(using: &tranceform)!)
        context.clip()
    }
    private func _disableMask() {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        context.resetClip()
    }
}
