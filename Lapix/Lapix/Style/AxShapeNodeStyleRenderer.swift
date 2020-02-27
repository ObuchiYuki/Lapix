//
//  AxStyleRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/23.
//  Copyright © 2020 yuki. All rights reserved.
//

import Cocoa
import SketchKit


class AxShapeNodeStyleRenderer {
    public static let shared = AxShapeNodeStyleRenderer()
    
    private let shadowRenderer = AxShadowStyleRenderer()
    private let fillRenderer = AxFillStyleRenderer()
    private let borderRenderer = AxBorderStyleRenderer()
    private let innerShadowRenderer = AxInnerShadowRenderer()
    
    func drawStyle(_ style: SKTStyle, rect: CGRect , path: CGPath) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        context.saveGState()
        defer {
            context.restoreGState()
            context.resetSetting()
        }
        
        if let setting = style.contextSettings { context.applySetting(setting) }
                
        for shadow in style.shadows ?? [] {
            guard shadow.isEnabled else { continue }
            
            shadowRenderer.drawShadow(shadow, rect: rect, path: path, into: context)
        }
        for fill in style.fills ?? [] {
            guard fill.isEnabled else { continue }
            
            fillRenderer.drawFill(fill, rect: rect, path: path, into: context)
        }
        for boarder in style.borders ?? [] {
            guard boarder.isEnabled else { continue }
            
            borderRenderer.drawBorder(boarder, borderOptions: style.borderOptions, rect: rect, path: path, into: context)
        }
        for innerShadow in style.innerShadows ?? [] {
            guard innerShadow.isEnabled else { continue }
            
            innerShadowRenderer.drawInnerShadow(innerShadow, rect: rect, path: path, into: context)
        }
    }
}
