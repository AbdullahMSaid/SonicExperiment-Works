//
//  ViewController.swift
//  SonicExperiment
//
//  Created by Thomas Watts on 6/11/19.
//  Copyright © 2019 Thomas Watts. All rights reserved.
//

import UIKit
import AudioKit

//Extension that allows access to UIImage dimensions once displayed and scaled
extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

class ViewController: UIViewController, UIPencilInteractionDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    //Tagged Points#imageLiteral(resourceName: "IMG_F3A5B6566242-1.jpeg")
    var taggedPoints : [CGPoint] = []
    
    //Rhombus mode
    var unitCellMode: Bool = false
    
    //Image Variables
    var image: UIImage!
    var scaledImageSize : CGSize! //Image Size Onced Scaled
    var scaledImageOrigin : CGPoint! //Image Origin Coordinates Once Scaled
    
    //Finger and Pencil Recognizers
    var pencilStrokeRecognizer: StrokeGestureRecognizer!
    
    //AudioKit Variables
    var oscillator = AKFMOscillator()
    var oscillator2 = AKFMOscillator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Image
        self.image = UIImage(named: "gausshighres.png")!
        imageView.image = self.image
        self.scaledImageSize = imageView.contentClippingRect.size
        self.scaledImageOrigin = imageView.contentClippingRect.origin
        
        //Set ScrollView
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        scrollView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        scrollView.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        scrollView.delaysContentTouches = false
    
        
        //Set Pencil Stroke Gesture Recognizer
        self.pencilStrokeRecognizer = setupStrokeGestureRecognizer(isForPencil: false)
        
        //Set Double Tap Gesture
        let doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        //Set Apple Pencil Double Tap Gesture
        let pencilInteraction = UIPencilInteraction()
        pencilInteraction.delegate = self
        view.addInteraction(pencilInteraction)
       
        
        //Set AudioKit
        self.oscillator.amplitude = 0.0
        self.oscillator2.amplitude = 0.0
        
        let mix1 = AKMixer(self.oscillator, self.oscillator2)
        let delay = AKDelay(mix1)
        delay.feedback = 0.3
        delay.time = 0.1
        let reverb = AKCostelloReverb(delay)
        let mix2 = AKDryWetMixer(delay, reverb, balance: 0.5)
        let moogLadder = AKMoogLadder(mix2)
        moogLadder.resonance = 0.6
        AudioKit.output = moogLadder
        try? AudioKit.start()
        
        self.unitCellMode = false
            
        
    }
    
    
    //Allow for zooming within ScrollView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    //Set Up Pencil Touch Input Recognizer
    func setupStrokeGestureRecognizer(isForPencil: Bool) -> StrokeGestureRecognizer {
        let recognizer = StrokeGestureRecognizer(target: self, action: #selector(self.strokeAction))
        recognizer.delegate = self
        recognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(recognizer)
        recognizer.coordinateSpaceView = imageView
        recognizer.isForPencil = isForPencil
        recognizer.size = self.scaledImageSize
        recognizer.origin = self.scaledImageOrigin
        recognizer.imageSize = self.image.size
        return recognizer
    }
    
    //Produce Sound Based on Location of Touch Input
    @objc func strokeAction(gesture: StrokeGestureRecognizer){
        if pencilStrokeRecognizer.state != .ended && pencilStrokeRecognizer.touchInImage == true {
            if !self.oscillator.isStarted {
                self.oscillator.start()
                self.oscillator2.start()
            }
            
            //Get pencil touch input location with respect to input image
            let x = pencilStrokeRecognizer.touchLocation.x
            let y = pencilStrokeRecognizer.touchLocation.y
            
            
            if self.unitCellMode == false {
                //Get Grayscale Value at Point User is Touching on Screen
                let grayVal = Double(OpenCVWrapper.getGrayVal(Int32(round(y)),Int32(round(x))))
                let grayUp = Double(OpenCVWrapper.getGrayVal(Int32(round(y - 33)),Int32(round(x))))
            
                
                //let grayN = (grayLeft + grayRight)/2
                let grayAvg = (grayVal + grayUp)/2
                //Set loudness of sound and
                //change frequency based on grayscale intensity value at the pixel
                self.oscillator.amplitude = 0.5
                
                if grayVal < 10000.0 {
                    self.oscillator.amplitude = 0.0
                    self.oscillator2.amplitude = 0.0
                } else if grayVal < 23000.0 && grayAvg < 15000.0 {
                    //Discord
                    self.oscillator.baseFrequency = grayVal/70.0
                    self.oscillator2.amplitude = 0.0
                } else {
                    //Harmony
                    self.oscillator.amplitude = 0.3
                    self.oscillator.baseFrequency = 440.0
                    self.oscillator2.baseFrequency = 330.0
                    
                }
                
            } else if x-18 >= 0 && y-15 >= 0 && x+18 < image.size.width && y+15 < image.size.height {
                
                //Atoms of center rhombus
                let atom1 = Double(OpenCVWrapper.getGrayVal(Int32(round(y)),Int32(round(x-18))))
                let atom2 = Double(OpenCVWrapper.getGrayVal(Int32(round(y)),Int32(round(x+18))))
                let atom3 = Double(OpenCVWrapper.getGrayVal(Int32(round(y-15)),Int32(round(x))))
                let atom4 = Double(OpenCVWrapper.getGrayVal(Int32(round(y+15)),Int32(round(x))))
                
                
                //Atoms of outer-most rhombus
                let atom5 = Double(OpenCVWrapper.getGrayVal(Int32(round(y)),Int32(round(x-39))))
                let atom6 = Double(OpenCVWrapper.getGrayVal(Int32(round(y)),Int32(round(x+39))))
                let atom7 = Double(OpenCVWrapper.getGrayVal(Int32(round(y-60)),Int32(round(x))))
                let atom8 = Double(OpenCVWrapper.getGrayVal(Int32(round(y+60)),Int32(round(x))))
                
                //Lone Pairs one
                let atom9 = Double(OpenCVWrapper.getGrayVal(Int32(round(y-24)),Int32(round(x-28))))
                let atom10 = Double(OpenCVWrapper.getGrayVal(Int32(round(y-24)),Int32(round(x+28))))
                let atom11 = Double(OpenCVWrapper.getGrayVal(Int32(round(y+24)),Int32(round(x-28))))
                let atom12 = Double(OpenCVWrapper.getGrayVal(Int32(round(y+24)),Int32(round(x+28))))
                
                //Lone Pairs two
                let atom13 = Double(OpenCVWrapper.getGrayVal(Int32(round(y-37)),Int32(round(x-11))))
                let atom14 = Double(OpenCVWrapper.getGrayVal(Int32(round(y-37)),Int32(round(x+11))))
                let atom15 = Double(OpenCVWrapper.getGrayVal(Int32(round(y+37)),Int32(round(x-11))))
                let atom16 = Double(OpenCVWrapper.getGrayVal(Int32(round(y+37)),Int32(round(x+11))))
                
                let grayVal = (atom1+atom2+atom3+atom4+atom5+atom6+atom7+atom8+atom9+atom10+atom11+atom12+atom13+atom14+atom15+atom16)/16
                
                self.oscillator.amplitude = 0.7
                self.oscillator.baseFrequency = grayVal/120.0
            }
        } else {
            //If touch input has ended, make oscillator quiet
            self.oscillator.amplitude = 0.0
            self.oscillator2.amplitude = 0.0
        }
    }
    
    
    //Double Tap Action Event
    @objc func doubleTapAction(gesture: UITapGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.ended && pencilStrokeRecognizer.touchLocation != nil {
            //Get pencil touch input location with respect to input image
            let x = pencilStrokeRecognizer.touchLocation.x
            let y = pencilStrokeRecognizer.touchLocation.y
            
            taggedPoints.append(CGPoint(x:Double(round(x)), y:Double(round(y))))
            
            //Draw blue dots to visualize line
            let radius = 4
            let xCoord = Int(pencilStrokeRecognizer.lastTouch.x-1.5)
            let yCoord = Int(pencilStrokeRecognizer.lastTouch.y-1.5)
            
            let dotPath = UIBezierPath(ovalIn: CGRect(x: xCoord, y: yCoord, width: radius, height: radius))
            
            let layer = CAShapeLayer()
            layer.path = dotPath.cgPath
            layer.strokeColor = UIColor.blue.cgColor
            
            imageView.layer.addSublayer(layer)
        }
    }
    
    //Change Mode of Sonic Analysis Based on Apple Pencil Double Tap Input
    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        if self.unitCellMode == false {
            self.unitCellMode = true
            imageView.layer.sublayers = nil
        } else {
            self.unitCellMode = false
        }
        
        
    }
    
    
    
    
    
    

}
