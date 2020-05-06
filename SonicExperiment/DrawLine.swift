//
//  DrawLine.swift
//  SonicExperiment
//
//  Created by Thomas Watts on 6/25/19.
//  Copyright © 2019 Thomas Watts. All rights reserved.
//

import Foundation
import UIKit

//Find points on the line from user first touch to second touch
//Useing digitial differential analyzer
func findLinePoints(p: CGPoint, q: CGPoint) -> Double{
    //Get grayscale value at point p
    let m : CGFloat = (q.y-p.y)/(q.x-p.x)
    var grayVal : Double = Double(OpenCVWrapper.getGrayVal(Int32(round(p.x)), Int32(round(p.y))))
    var n : Double = 1.0
    var intPoint : CGPoint = p
    
    if abs(m) <= 1 {
        while Int(intPoint.x) != Int(q.x) {
            if p.x < q.x {
                intPoint.y = intPoint.y + m
                intPoint.x = intPoint.x + 1
            } else {
                intPoint.y = intPoint.y - m
                intPoint.x = intPoint.x - 1
            }
            //Get grayscale value at current intPoint
            grayVal += Double(OpenCVWrapper.getGrayVal(Int32(round(intPoint.y)), Int32(round(intPoint.x))))
            n += 1.0
        }
    } else {
        while Int(intPoint.y) != Int(q.y) {
            if p.y < q.y {
                intPoint.y = intPoint.y + 1
                intPoint.x = intPoint.x + (1/m)
                
            } else {
                intPoint.y = intPoint.y - 1
                intPoint.x = intPoint.x - (1/m)
            }
            //Get grayscale value at current intPoint
            grayVal += Double(OpenCVWrapper.getGrayVal(Int32(round(intPoint.y)), Int32(round(intPoint.x))))
            n += 1.0
        }
    }
    return (grayVal/n)
    
}


