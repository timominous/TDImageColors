//
//  UIImage+TDAdditions.h
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TDAdditions)

// From http://stackoverflow.com/a/1262893
+ (NSString *)colorHexFromImage:(UIImage *)image atX:(int)x andY:(int)y;
+ (UIColor *)colorFromImage:(UIImage *)image atX:(int)x andY:(int)y;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
