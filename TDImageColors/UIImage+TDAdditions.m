//
//  UIImage+TDAdditions.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "UIImage+TDAdditions.h"

@implementation UIImage (TDAdditions)


+ (NSString *)colorHexFromImage:(UIImage *)image atX:(NSInteger)x andY:(NSInteger)y {
  
  // Put image in buffer
  CGImageRef imageRef = image.CGImage;
  NSUInteger width = CGImageGetWidth(imageRef) / image.scale;
  NSUInteger height = CGImageGetHeight(imageRef) / image.scale;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
  NSUInteger bytesPerPixel = 4;
  NSUInteger bytesPerRow = bytesPerPixel * width;
  NSUInteger bitsPerComponent = 8;
  CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow,
                                               colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
  CGContextRelease(context);
  
  // rawDara now contains the image data in RGBA8888
  NSInteger byteIndex = (bytesPerRow * y) + (x * bytesPerPixel);
  
  CGFloat red = (rawData[byteIndex] * 1.f);
  CGFloat green = (rawData[byteIndex + 1] * 1.f);
  CGFloat blue = (rawData[byteIndex + 2] * 1.f);
  free(rawData);
  
  return [NSString stringWithFormat:@"#%02X%02X%02X", (int)red, (int)green, (int)blue];
}

+ (UIColor *)colorFromImage:(UIImage *)image atX:(NSInteger)x andY:(NSInteger)y {
  
  // Put image in buffer
  CGImageRef imageRef = image.CGImage;
  NSUInteger width = CGImageGetWidth(imageRef);
  NSUInteger height = CGImageGetHeight(imageRef);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
  NSUInteger bytesPerPixel = 4;
  NSUInteger bytesPerRow = bytesPerPixel * width;
  NSUInteger bitsPerComponent = 8;
  CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow,
                                               colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
  CGContextRelease(context);
  
  // rawDara now contains the image data in RGBA8888
  NSInteger byteIndex = (bytesPerRow * y) + (x * bytesPerPixel);
  
  CGFloat red = (rawData[byteIndex] * 1.f) / 255.f;
  CGFloat green = (rawData[byteIndex + 1] * 1.f) / 255.f;
  CGFloat blue = (rawData[byteIndex + 2] * 1.f) / 255.f;
  CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.f;
  free(rawData);
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end
