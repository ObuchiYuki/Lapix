//
//  AxCanvasView.swift
//  AxRenderCore
//
//  Created by yuki on 2020/02/08.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit
import Cocoa

public class AxArtboardView: NSView {
    let renderer = AxLayerNodeRenderer.shared
    public var artboard: SKTArtboard? {
        didSet {
            guard let artboard = artboard else { return }
            self.frame.size = artboard.frame.size
        }
    }
    
    public override var isFlipped: Bool { true }
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState() ; defer { NSGraphicsContext.restoreGraphicsState() }
        
        guard let artboard = artboard else { return }
        renderer.drawArtboard(artboard)
    }
}
