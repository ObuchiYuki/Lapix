//
//  Ex+CGPath+Boolian.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/25.
//  Copyright © 2020 yuki. All rights reserved.
//

import SketchKit
import Foundation

extension CGPath {
    static func union(_ path1: CGPath, _ path2: CGPath) -> CGPath {
        return CGPath_FBCreateUnion(path1, path2).takeRetainedValue()
    }
    static func subtract(_ path1: CGPath, _ path2: CGPath) -> CGPath {
        return CGPath_FBCreateDifference(path1, path2).takeRetainedValue()
    }
    static func intersect(_ path1: CGPath, _ path2: CGPath) -> CGPath {
        return CGPath_FBCreateIntersect(path1, path2).takeRetainedValue()
    }
    static func diffrence(_ path1: CGPath, _ path2: CGPath) -> CGPath {
        return CGPath_FBCreateXOR(path1, path2).takeRetainedValue()
    }
}

extension CGContext {
    private static var __key = "CGContext.alpha__key"
    private var alpha: CGFloat {
        get { objc_getAssociatedObject(self, &CGContext.__key) as? CGFloat ?? 1 }
        set { objc_setAssociatedObject(self, &CGContext.__key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    func resetSetting() {
        self.alpha = 1
    }
    func applySetting(_ setting: SKTGraphicsContextSettings) {
        self.setBlendMode(setting.blendMode)
        
        self.alpha *= setting.opacity
        self.setAlpha(self.alpha)
    }
}
