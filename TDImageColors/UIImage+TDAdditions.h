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
+ (NSString *)colorHexFromImage:(UIImage *)image atX:(NSInteger)x andY:(NSInteger)y;
+ (UIColor *)colorFromImage:(UIImage *)image atX:(NSInteger)x andY:(NSInteger)y;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
