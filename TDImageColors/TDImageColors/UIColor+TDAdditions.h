//
//  UIColor+TDAdditions.h
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TDAdditions)

- (CGFloat)luminance;
- (BOOL)isDarkColor;
- (BOOL)isBlackOrWhite;
- (BOOL)isDistinct:(UIColor *)color;
- (BOOL)isContrastingColor:(UIColor *)color;
- (UIColor *)colorWithMinimumSaturation:(CGFloat)saturation;

@end
