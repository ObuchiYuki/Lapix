//
//  AxTextRenderer.swift
//  AxRenderCoreSample
//
//  Created by yuki on 2020/01/27.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation
import SketchKit

class AxTextRenderer {
    func drawText(_ text: SKTText, origin: CGPoint) {
        let arttiString: NSAttributedString
        if let cached:NSAttributedString = text.cache.get(for: .text) {
            arttiString = cached
        }else{
            let attributedString = text.attributedString
            let string = attributedString.string
            
            let containerString = NSMutableAttributedString()
            
            for attribute in attributedString.attributes {
                let substring = string.substring(with: NSRange(location: attribute.location, length: attribute.length))
                let attribStr = NSAttributedString(string: substring, attributes: attribute.attributes!)
                
                containerString.append(attribStr)
            }
            
            arttiString = containerString
            text.cache.set(containerString, for: .text)
        }
        
        let rect = CGRect(origin: text.frame.origin + origin, size: text.frame.size)
        arttiString.draw(in: rect)
    }
}
