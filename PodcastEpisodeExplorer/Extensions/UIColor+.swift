//
//  UIColor+.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let appPink = #colorLiteral(red: 0.9944344163, green: 0.8656131029, blue: 0.8500242233, alpha: 1)
    static let appRed = #colorLiteral(red: 0.9944505095, green: 0.2060118914, blue: 0.1765429974, alpha: 1)
    static let appBlack = #colorLiteral(red: 0.05490196078, green: 0.05490196078, blue: 0.05490196078, alpha: 1)
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
