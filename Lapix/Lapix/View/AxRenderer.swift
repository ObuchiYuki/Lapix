//
//  AxRenderer.swift
//  AxRenderCore
//
//  Created by yuki on 2020/02/09.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit

public class AxRenderer {
    public static let shared = AxRenderer()
    
    public func drawArtboard(_ artboard: SKTArtboard, origin: CGPoint = .zero) {
        AxLayerNodeRenderer.shared.drawArtboard(artboard, origin: origin)
    }
}
