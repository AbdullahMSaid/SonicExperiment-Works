


<p align="center">
<kbd><img src="https://raw.githubusercontent.com/AbdullahMSaid/SonicExperiment-Works/master/Photos%20for%20Sonic%20Project/Screen%20Shot%202020-05-06%20at%2011.24.18%20PM.png" alt="" width="400" style="border: 1px solid black" align="center"/>
 </p>

[![Platform](https://img.shields.io/cocoapods/p/SnapKit.svg?style=flat)](https://github.com/SnapKit/SnapKit)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/SnapKit.svg)](https://cocoapods.org/pods/SnapKit)



## Contents

 

- [Requirements](#requirements)
- [Introduction](#Introduction)
- [Migration Guides](#migration-guides)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
- [Code Explanation](#code explanation)
- [License](#license)

## Introduction

Files to look at before beginning this project 

[Sonic Atomic Project Introduction](https://github.com/AbdullahMSaid/SonicExperiment-Works/blob/master/SonicAtomicPresentation.key)

## Requirements

<p align="center">
<img src="https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iOS/ios13-ipad-pro-apple-pencil-connect.jpg" alt="" width="400" style="border: 1px solid black" align="center"/>
 </p>


- iOS 10.0+ / Mac OS X 10.12+ 
- iPad 12.9-inch with Apple Pencil
- Xcode 10.0+
- Swift 4.0+
- Headphones (Bluetooth or Type-C wired)

## Communication

- If you **need help**, email me at said.44@osu.edu 
- CEMAS contact: https://cemas.osu.edu/
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, email Professor Jinwoo Hwang at hwang.458@osu.edu


## Installation

#### Intial Set Up Process 

##### Frameworks needed 

 + [CocoaPods](http://cocoapods.org) 
 + [OpenCV](https://sourceforge.net/projects/opencvlibrary/files/4.3.0/opencv-4.3.0-ios-framework.zip/download)

##### How to install said Frameworks

[Sonic Intial Code Guideline](https://github.com/AbdullahMSaid/SonicExperiment-Works/blob/master/SonicAtomic%20Code%20Guide.pdf)

##### Zip File of Working Sonic Frameworks 


[Files with all the Necessary Code together](https://osu.box.com/s/7w6yjrapfp2idhzv91hc5kgf70u6rzqw)

##### Demostration Video 

[<img src="https://raw.githubusercontent.com/AbdullahMSaid/SonicExperiment-Works/master/Photos%20for%20Sonic%20Project/Screen%20Shot%202020-05-07%20at%201.14.28%20AM.png" alt="" width="700" style="border: 1px solid black"/>](https://osu.box.com/s/00ff4juow6cxpxsi79ylgomaij7kp23b)





### CocoaPods(this piece of isn't used)

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build SnapKit 4.0.0+.

To integrate SnapKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SnapKit', '~> 5.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```



### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate SnapKit into your project manually.

---

## Usage

### Quick Start

```swift
import SnapKit

class MyViewController: UIViewController {

    lazy var box = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(box)
        box.backgroundColor = .green
        box.snp.makeConstraints { (make) -> Void in
           make.width.height.equalTo(50)
           make.center.equalTo(self.view)
        }
    }

}
```

### Playground

You can try SnapKit in Playground.

**Note:**

> Resources

- [Documentation](http://snapkit.io/docs/)
- [F.A.Q.](http://snapkit.io/faq/)

# Code Explanation 

### Initial File Set up 



![Screen Shot 2020-05-08 at 11.20.04 PM.png](https://github.com/AbdullahMSaid/SonicExperiment-Works/blob/master/Photos%20for%20Sonic%20Project/Screen%20Shot%202020-05-08%20at%2011.20.04%20PM.png?raw=true)

The zip file that is downloaded will look like the only file of consern will be that worlplace file. Consult apple's Swift book (Linked in Supplementary Resources) on how to edit and change files. The frameworks may needed to be updated every 6-12 months. XCode will have error messages if this is the case. 



<p align="center">
<img src="https://raw.githubusercontent.com/AbdullahMSaid/SonicExperiment-Works/master/Photos%20for%20Sonic%20Project/Layout%20of%20Workspace.png" alt="" width="800" style="border: 1px solid black" align="center"/>
 </p>



This is the workspace file running on XCode. In order: 

+ AppDelegate
  + Uses UIApplication class to cordinate what the app should do when being closed, running in the background and so on. If there is an issue in logic this won't be the place to find it. 
+ ViewController 
  + This is where the actions actually happen. It incorapres the OpenCVwrapper, Pen and the Audiokit. This pulls everything together. I would insure "StrokeGesture"  works before messing with this. 
+ StrokeGestureRecognizer
  + This is where viewcontroller get's most of the input from the user from. Most Errors were found here. Start her
+ gausshighres.png
  + The photo needs to be grayscale and 1024 by 1024. The grayscale is for OpenCV to work. But the resolution is what the alignment is based off of. If you need more StrokeGestureRecognizer will need to be changed. 
    + Feature of using multiple photo is the eventual goal

+ OpenCVWrapper files 
  + These are how the application determines the "gray" value. It's not about the color gray. It's like the pixel intensity or how white the pixel is. True black spots render 0 values with white areas having a larger value. This will be discussed more. 
  + .mm is for objective C++
  + .h is for header files 
+ SonicExperiment-Bridging-Header.h
  + Used to import target's public header to be used in swift 

### Stroke Gesture Recogniser Explained. 



```swift
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
```

This section of code just imports UIKit to then make a class. This class tells if the pencil or the finger is being used. Then variables are intialized 



```swift
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
```



This section of code establishes where the touch is relative on the iPad screen. There are basically 2 screens that are being interacted with. The screen the iPad "sees" and the screen the user sees. This establishes the touch from the iPad end and as long as the code matches the sizing of the two screens they overlap. 

```swift
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
            
            //image size width and height = 1024.0
            //Size of width and height = 1004.0
            
            //ratio=1.02
            
           // let  ratio1 = imageSize.width / size.width
           // let  ratio2 = imageSize.height / size.height
            
           // print("ratio1: ",ratio1)
           // print("ratio2: ",ratio2)
            
            //print("currentpoint.x :", currentPoint.x )
            //print("currentpoint.y :", currentPoint.y )
            
            //print("origin.x :", origin.x )
            //print("origin.y :", origin.y )
            
            let xVal = (1.046)*(currentPoint.x - (origin.x+14))
            let yVal = (1.046)*(currentPoint.y - origin.y)
            
            
           // let xVal = (imageSize.width / size.width)/(currentPoint.x - origin.x)
            
           // let yVal = (currentPoint.y - origin.y)/(imageSize.height / size.height)
            
            //Record Touch Location
            touchLocation = CGPoint(x: xVal, y: yVal)
            lastTouch = currentPoint
        }
    }

}
```



This section of code deals with what the user seas and then trying to match the sizes. The screen on the iPad is a 1004x1004. While the image is 1024x1024. Originally the x/y values were based off this ratio. But for some reason swift scales from the left edge. Later on I'll explain how to fix if this goes wrong using a calibration image I've made. But for now that's what the code looks like and the comments were how I got to that. The values where selected based off of shifting the left or scaling up and down. The y value started from the top so it was just a matter of scaling. The xvalue started from the left so after it was scaled correctly it had to be shifted 14 (xvalues). These are then passed on to the touch location function. 





### View Controller Explained. 

```swift
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
```

This displays the UI image (ie the one the iPad sees). I wouldn't mess with this side of the two screens since it's harder to fix once broken. 



```swift
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
```



This is one of the main classes View controller. This does a lot of things from recognizing the pencil, the sound generation, and so on. It's being intilaized here. 

```swift
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
        scrollView.panGestureRecognizer.allowedTouchTypes =[UITouch.TouchType.direct.rawValue as NSNumber] //this is shifted 
        scrollView.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber] //this is also shifted
        scrollView.delaysContentTouches = false
```

The UI touch should be shifted to the first "l" in scroll view. But your setting the image and the scaling. 

```swift
//Set Pencil Stroke Gesture Recognizer
        //false = use computer mouse
        self.pencilStrokeRecognizer = setupStrokeGestureRecognizer(isForPencil: true)
        //only works on 12.9 inch IPad
        
        
        //Set Double Tap Gesture
        //let doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction))
        //doubleTapGesture.numberOfTapsRequired = 2
        //view.addGestureRecognizer(doubleTapGesture)
        
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
```



Last of the class. Overall it just sets the sound. If you're running the simulation on your computer set the the self.pencilStrokeRecognizer to false. Now you have all ingredients to make the sound work. 



```swift
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
```



This was the stroke recognizer used in the last file. Even though this file was made before the last one I choose to do this second because the I decided it was easier to understand was done then see what was happening then where it came from. You called the pencil functions but now you have to get the screen to see the pencil, decide it's on the screen, where on the screen and so on. This set of code make sense and shouldn't cause any trouble. 



```swift
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
            
           // print("x:",x)
           // print("y:",y)
            
            //Get Grayscale Value at Point User is Touching on Screen
            let grayVal = Double(OpenCVWrapper.getGrayVal(Int32(round(y)),Int32(round(x))))
           // let grayUp = Double(OpenCVWrapper.getGrayVal(Int32(round(y - 33)),Int32(round(x))))
                    
           //print("grayVal: ",grayVal)
           // print("grayUp: ",grayUp)
            self.oscillator.amplitude = 0.7
            self.oscillator.baseFrequency = grayVal/120.0
            
        }
            else {
            //If touch input has ended, make oscillator quiet
            self.oscillator.amplitude = 0.0
            self.oscillator2.amplitude = 0.0
        }
    }

    


```

This section is where it all the information outside of the scaling comes from. The pencil touches an area of the screen then if the scaling is done right the gray value is found. This value is then used to detemine the frequnency. This creates a sliding scale were as one value goes up the other does. If the sound is annoying to the users this section can be adjusted. 

```swift
    //Change Mode of Sonic Analysis Based on Apple Pencil Double Tap Input
    func pencilInteractionDidTap(_interaction: UIPencilInteraction) {
        if self.unitCellMode == false {
            self.unitCellMode = true
            imageView.layer.sublayers = nil
        } else {
            self.unitCellMode = false
        }     
    }
}
```

Double tap action was a prototype feature that was never implemented. I had plans on fixing that also, but it wasn't relavant to the MVP.  

## License

Check out cemas.osu.edu for Licensing. 
