//
//  Extensions.swift
//  YGAM
//
//  Created by Jon Fulton on 07/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

extension UILabel{
    
    func adjustedFont()->UIFont {
        let attributes: [NSAttributedStringKey: Any] = [.font: font]
        let attributedString = NSAttributedString(string: text ?? "", attributes: attributes)
        let drawingContext = NSStringDrawingContext()
        drawingContext.minimumScaleFactor = minimumScaleFactor
        
        attributedString.boundingRect(with: bounds.integral.size,
                                      options: .usesLineFragmentOrigin,
                                      context: drawingContext)
        
        let fontSize = font.pointSize * drawingContext.actualScaleFactor
        
        return font.withSize(fontSize)
    }
    
    func fitMaxWord(){
        layoutIfNeeded()
        let scaledFont = self.adjustedFont()
        let currentFont = scaledFont
        if let txt = text,
            let maxString = txt.components(separatedBy: " ").max(by: {$1.count > $0.count})?.replacingOccurrences(of: "\n", with: ""){
            let maxFontSize: CGFloat = currentFont.pointSize
            let minFontSize: CGFloat = 5.0
            
            
            var q = maxFontSize
            var p = minFontSize
            let height = currentFont.lineHeight
            let constraintSize = CGSize(width: .greatestFiniteMagnitude, height: height)
            var sizedFont = currentFont
            while(p <= q){
                let currentSize = (p + q) / CGFloat(2)
                sizedFont = currentFont.withSize( CGFloat(currentSize) )
                
                let text = NSMutableAttributedString(string:maxString, attributes:[NSAttributedStringKey.font:sizedFont])
                
                let textRect = text.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin], context: nil).integral
                let labelSize = textRect.width
                
                //1 is a fudge factor
                if labelSize == ceil(self.bounds.width - 1){
                    break
                }else if labelSize > ceil(self.bounds.width - 1){
                    q = currentSize - 0.1
                }else{
                    p = currentSize + 0.1
                }
            }
            
            if sizedFont.pointSize < currentFont.pointSize{
                self.font = sizedFont
            }
        }
    }
}
