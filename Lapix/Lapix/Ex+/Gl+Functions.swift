//
//  Gl+Functions.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/28.
//  Copyright © 2020 yuki. All rights reserved.
//

import CoreUtil
import Foundation

extension NSScreen {
    static var scaleFactor: CGFloat = NSScreen.main!.backingScaleFactor
}


extension CGLayer {
    static func create(context: CGContext, size: CGSize, scale: CGFloat = NSScreen.scaleFactor) -> CGLayer? {
        guard
            let cgLayer = CGLayer(context, size: size * scale, auxiliaryInfo: nil),
            let ccontext = cgLayer.context
        else { return nil }
        
        ccontext.scaleBy(x: scale, y: scale)
        
        return cgLayer
        
    }
}
