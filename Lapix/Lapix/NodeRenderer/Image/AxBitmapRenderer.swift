//
//  AxBitmapRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/27.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation
import SketchKit

class AxBitmapRenderer {
    func drawBitmap(_ bitmap: SKTBitmap, origin: CGPoint) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let bitmapLayer: CGLayer
        
        if let cachedLayer: CGLayer = bitmap.cache.get(for: .layer) {
            bitmapLayer = cachedLayer
        }else{
            guard let cgLayer = _createBitmapLayer(bitmap, with: context) else { return }
            bitmap.cache.set(cgLayer, for: .layer)
            bitmapLayer = cgLayer
        }
        
        context.draw(bitmapLayer, at: bitmap.frame.origin + origin)
    }
    
    private func _createBitmapLayer(_ bitmap: SKTBitmap, with context: CGContext) -> CGLayer? {
        // MARK: - Create New NSGraphicsContext -
        
        guard
            let cgLayer = CGLayer(context, size: bitmap.frame.size, auxiliaryInfo: nil),
            let cgContext = cgLayer.context
        else { return nil }
        
        let nsContext = NSGraphicsContext(cgContext: cgContext, flipped: true)
        
        NSGraphicsContext.saveGraphicsState()
        
        NSGraphicsContext.current = nsContext
        
        // MARK: - Draw -
        
        guard
            let imageData = bitmap.image.data,
            let image = NSImage(data: imageData as Data)
        else { return nil }
        
        let rect = CGRect(origin: .zero, size: bitmap.frame.size)
        
        image.draw(in: rect)
        
        NSGraphicsContext.restoreGraphicsState()
        
        return cgLayer
    }
}
