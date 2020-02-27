//
//  Ex+SKTNode.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/27.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation
import SketchKit

class AxCache {
    private var container = NSMutableDictionary()
    
    func get<T>(for name: Name) -> T? {
        return container[name.identifier] as? T
    }
    func set(_ value: AnyObject, for name: Name) {
        self.container[name.identifier] = value
    }
    
    func reset() {
        self.container.removeAllObjects()
    }
}

extension AxCache {
    struct Name {
        fileprivate let identifier: String
        
        init(identifier: String) {
            self.identifier = identifier
        }
    }
}

extension AxCache.Name {
    static let text = AxCache.Name(identifier: "__text")
    static let path = AxCache.Name(identifier: "__path")
    static let layer = AxCache.Name(identifier: "__layer")
}

extension SKTNode {
    private static var __cacheKey = "SKTNode.cache__key"
    func setModified() {
        self.cache.reset()
    }
    
    var cache: AxCache {
        let assoc = objc_getAssociatedObject(self, &SKTNode.__cacheKey)
        if assoc == nil || !(assoc is AxCache) {
            objc_setAssociatedObject(self, &SKTNode.__cacheKey, AxCache(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
            
        return objc_getAssociatedObject(self, &SKTNode.__cacheKey) as! AxCache
    }
}
