//
//  OpenCVWrapper.mm
//  SonicExperiment
//
//  Created by Thomas Watts on 6/11/19.
//  Copyright © 2019 Thomas Watts. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
@implementation OpenCVWrapper

+ (UInt16) getGrayVal:(int)i :(int)j{
    cv::Mat grayMat;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gausshighres" ofType:@"png"];
    const char * cpath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    grayMat = cv::imread(cpath,cv::IMREAD_ANYDEPTH);
    return grayMat.at<UInt16>(i, j);
}
@end
