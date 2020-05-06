//
//  OpenCVWrapper.h
//  SonicExperiment
//
//  Created by Thomas Watts on 6/11/19.
//  Copyright © 2019 Thomas Watts. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
+ (UInt16) getGrayVal:(int)i :(int)j;
@end

NS_ASSUME_NONNULL_END
