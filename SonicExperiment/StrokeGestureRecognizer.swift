//
//  StrokeGestureRecognizer.swift
//  SonicExperiment
//
//  Created by Thomas Watts on 6/11/19.
//  Copyright © 2019 Thomas Watts. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// A custom gesture recognizer that receives Apple Pencil touch input
class StrokeGestureRecognizer: UIGestureRecognizer {
    //Variable to determine whether gesture recognizer should recieve Apple Pencil touch input or finger touch input
    //A feature intended to allow for finger touch input support to be used in future versions
    var isForPencil: Bool = true {
        didSet {
            if isForPencil {
                allowedTouchTypes = [UITouch.TouchType.pencil.rawValue as NSNumber]
            } else {
                allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
            }
        }
    }

    //Class Variables
    var coordinateSpaceView: UIView?
    var size : CGSize!
    var origin : CGPoint!
    var imageSize : CGSize!
    var touchLocation : CGPoint!
    var lastTouch : CGPoint!
    var touchInImage : Bool = false
    
    
    //Touch Tracking Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        //Find point where pencil is touching with respect to the input image
        pencilTouchHandler(touch: touch)
        //Run Action Method in View Controller now that user has began stroke so to start producing sound
        state = .began
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        //Find point where pencil is touching with respect to the input image
        pencilTouchHandler(touch: touch)
        
        if state == .began {
            //Run Action Method in View Controller if stroke has began so to update sound produced
            state = .changed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Reset touchInImage boolean
        touchInImage = false
        //Run Action Method in View Controller if stroke has ended in order to silence oscillator
        state = .ended
    }
    
    //Calculate point at which pencil is touching with respect to the input image
    func pencilTouchHandler(touch: UITouch) {
        //Get point at which user is touching
        let currentPoint = touch.location(in: self.coordinateSpaceView)
        
        //Excute if touch input is within the image
        if currentPoint.x >= origin.x && currentPoint.y >= origin.y
            && currentPoint.x < (origin.x + size.width-1)
            && currentPoint.y < (origin.y + size.height-1){
            
            //Track whether or not touch was within the boundaries of the image
            touchInImage = true
            
            //Calculate (x,y) coordinates with respect to input image
            //Use ratio of original image dimensions
            let xVal = (imageSize.width / size.width)*(currentPoint.x - origin.x)
            let yVal = (imageSize.height / size.height)*(currentPoint.y - origin.y)
            
            //Record Touch Location
            touchLocation = CGPoint(x: xVal, y: yVal)
            lastTouch = currentPoint
        }
    }
    
    

}
