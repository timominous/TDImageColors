//
//  UIColor+TDAdditions.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "UIColor+TDAdditions.h"

@implementation UIColor (TDAdditions)

- (CGFloat)luminance {
  CGFloat r, g, b, a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return (0.2126f * r) + (0.7152f * g) + (0.0722 * b);
}

- (BOOL)isDarkColor {
  if (!self)
    return NO;
  
  if ([self luminance] < 0.5f)
    return YES;
  return NO;
}

- (BOOL)isBlackOrWhite {
  if (!self)
    return NO;
  
  CGFloat r, g, b, a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  if (r > 0.91f && g > 0.91f && b > 0.91f)
    return YES;
  if (r < 0.09f && g < 0.09f && b < 0.09f)
    return YES;
  return NO;
}

- (BOOL)isDistinct:(UIColor *)color {
  if (!self || !color)
    return NO;
  
  CGFloat r, g, b, a;
  CGFloat rc, gc, bc, ac;
  
  [self getRed:&r green:&g blue:&b alpha:&a];
  [color getRed:&rc green:&gc blue:&bc alpha:&ac];
  
  CGFloat threshold = 0.25f;
  
  if (fabs(r - rc) > threshold || fabs(g - gc) > threshold ||
      fabs(b - bc) > threshold || fabs(a - ac) > threshold) {
    // Check for grays
    if (fabs(r - g < 0.03f && fabs(r - b) < 0.03f)) {
      if (fabs(rc - gc) < 0.03f && (fabs(rc - bc) < 0.03f))
        return NO;
    }
    return YES;
  }
  
  return NO;
}

- (BOOL)isContrastingColor:(UIColor *)color {
  if (!self || !color)
    return YES;
  
  CGFloat r, g, b, a;
  CGFloat rc, gc, bc, ac;
  
  [self getRed:&r green:&g blue:&b alpha:&a];
  [color getRed:&rc green:&gc blue:&bc alpha:&ac];
  
  CGFloat contrast = 0.f;
  
  if ([self luminance] > [color luminance])
    contrast = ([self luminance] + 0.05f) / ([color luminance] + 0.05f);
  else
    contrast = ([color luminance] + 0.05f) / ([self luminance] + 0.05f);
  
  return contrast > 1.6f;
}

- (UIColor *)colorWithMinimumSaturation:(CGFloat)saturation {
  if (!self)
    return nil;
  
  CGFloat h, s, b, a;
  [self getHue:&h saturation:&s brightness:&b alpha:&a];
  
  if (s < saturation)
    return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
  
  return self;
}

@end
