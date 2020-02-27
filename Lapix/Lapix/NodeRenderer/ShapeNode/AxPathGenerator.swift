//
//  AxPathGenerator.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/26.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit
import CoreUtil
import Foundation

internal class AxPathGenerator {
    func generateShapeNodePath(_ node: SKTShapeNode) -> CGPath {
        
        let path: CGPath
        
        if let cachedPath:CGPath = node.cache.get(for: .path) {
            path = cachedPath
        }else{
            let newPath = _generateShapeNodePath(node)
            node.cache.set(newPath, for: .path)
            
            path = newPath
        }
        
        return path
        
    }
    func generateShapeGroupPath(_ node: SKTShapeGroup) -> CGPath {
        let path: CGPath
        
        if let cachedPath:CGPath = node.cache.get(for: .path) {
            path = cachedPath
        }else{
            let newPath = _generateShapeGroupPath(node)
            node.cache.set(newPath, for: .path)
            
            path = newPath
        }
        
        return path
    }
}


private func _generateShapeNodePath(_ shapeNode: SKTShapeNode, origin: CGPoint = .zero) -> CGPath {
    let path = CGMutablePath()
    
    guard !shapeNode.points.isEmpty else { return path }
    
    let scale = shapeNode.frame.scale
    
    path.move(to: shapeNode.points[0].point * scale + origin)
    
    let pointCount = shapeNode.points.count
    for i in 0..<pointCount {
        let fromPoint = shapeNode.points[i]
        let toPoint:SKTCurvePoint = shapeNode.points[(i+1) % pointCount]
        
        path.addCurve(
            to: toPoint.point * scale + origin,
            control1: (fromPoint.curveFrom * scale + origin),
            control2: (toPoint.curveTo * scale + origin)
        )
    }
    
    if shapeNode.isClosed {
        path.closeSubpath()
    }
        
    return path
}

private func _generateShapeGroupPath(_ shapeGroup: SKTShapeGroup) -> CGPath {
    var layers = shapeGroup.layers
    
    guard let base = layers.popFront() as? SKTShapeNode else { return CGMutablePath() }
    
    var basePath:CGPath = _generateShapeNodePath(base, origin: base.frame.origin)
    
    for layer in layers {
        guard let layer = layer as? SKTShapeNode else { continue }
        
        let layerPath = _generateShapeNodePath(layer, origin: layer.frame.origin)
        
        switch layer.booleanOperation {
            case .union:
                basePath = CGPath.union(basePath, layerPath)
            case .subtract:
                basePath = CGPath.subtract(basePath, layerPath)
            case .intersect:
                basePath = CGPath.intersect(basePath, layerPath)
            case .none, .diffrence:
                basePath = CGPath.diffrence(basePath, layerPath)
        }
    }
        
    return basePath
}
