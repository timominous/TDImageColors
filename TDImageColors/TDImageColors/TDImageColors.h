//
//  TDImageColors.h
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+TDAdditions.h"
#import "UIColor+TDAdditions.h"

#define kColorThresholdMinimumPercentage 0.01

@interface TDImageColors : NSObject

@property (strong, nonatomic, readonly) NSArray *colors;

- (id)initWithImage:(UIImage *)image count:(NSUInteger)count;

@end
