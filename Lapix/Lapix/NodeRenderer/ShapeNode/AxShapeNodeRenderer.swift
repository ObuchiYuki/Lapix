//
//  AxShapeNodeRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/26.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit


class AxShapeNodeRenderer {
    private let styleRenderer = AxShapeNodeStyleRenderer()
    
    func drawShapeNode(_ node: SKTShapeNode, origin: CGPoint, path: CGPath) {        
        guard let style = node.style else { return }
        
        let rect = CGRect(origin: origin + node.frame.origin, size: node.frame.size)
        styleRenderer.drawStyle(style, rect: rect, path: path)
    }
    
    func drawShapeGroup(_ node: SKTShapeGroup, origin: CGPoint, path: CGPath) {
        guard let style = node.style else { return }
        
        let rect = CGRect(origin: origin + node.frame.origin, size: node.frame.size)
        styleRenderer.drawStyle(style, rect: rect, path: path)
    }
}
