//
//  TDImageColors.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "TDImageColors.h"

#define TDIMAGECOLORS_SCALED_SIZE 100

@interface TDCountedColor : NSObject

@property (assign) NSUInteger count;
@property (strong) UIColor *color;

- (id)initWithColor:(UIColor *)color count:(NSUInteger)count;

@end

@interface TDImageColors ()
@property (nonatomic) NSUInteger count;
@property (strong, nonatomic, readwrite) NSArray *colors;
@property (strong, nonatomic) UIImage *scaledImage;
@end

@implementation TDImageColors

- (id)initWithImage:(UIImage *)image count:(NSUInteger)count {
  if ((self = [super init])) {
    self.count = count;
    self.colors = @[];
    self.scaledImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(TDIMAGECOLORS_SCALED_SIZE,
                                                                             TDIMAGECOLORS_SCALED_SIZE)];
    [self detectColorsFromImage:_scaledImage];
  }
  return self;
}

- (void)detectColorsFromImage:(UIImage *)image {
  if (!image)
    return;
  NSCountedSet *imageColors;
  NSMutableArray *finalColors = [NSMutableArray array];
  [finalColors addObjectsFromArray:[self findColorsOfImage:image imageColors:&imageColors]];
  while (finalColors.count < self.count)
    [finalColors addObject:[UIColor whiteColor]];
  self.colors = [NSArray arrayWithArray:finalColors];
}

- (NSArray *)findColorsOfImage:(UIImage *)image imageColors:(NSCountedSet **)colors {
  size_t width = CGImageGetWidth(image.CGImage);
  size_t height = CGImageGetHeight(image.CGImage);
  
  NSCountedSet *imageColors = [[NSCountedSet alloc] initWithCapacity:width * height];
  
  NSDate *start = [NSDate date];
  for (NSUInteger x = 0; x < width; x++) {
    for (NSUInteger y = 0; y < height; y++) {
      UIColor *color = [UIImage colorFromImage:image atX:x andY:y];
      [imageColors addObject:color];
    }
  }
  NSDate *finish = [NSDate date];
  NSTimeInterval execution = [finish timeIntervalSinceDate:start];
  
  *colors = imageColors;
  
  NSEnumerator *enumerator = [imageColors objectEnumerator];
  UIColor *curColor = nil;
  NSMutableArray *sortedColors = [NSMutableArray arrayWithCapacity:imageColors.count];
  NSMutableArray *resultColors = [NSMutableArray array];
  
  while ((curColor = [enumerator nextObject]) != nil) {
    curColor = [curColor colorWithMinimumSaturation:0.15f];
    NSUInteger colorCount = [imageColors countForObject:curColor];
    [sortedColors addObject:[[TDCountedColor alloc] initWithColor:curColor count:colorCount]];
  }
  
  [sortedColors sortUsingSelector:@selector(compare:)];
  
  for (TDCountedColor *countedColor in sortedColors) {
    curColor = countedColor.color;
    BOOL continueFlag = NO;
    for (UIColor *c in resultColors) {
      if (![curColor isDistinct:c]) {
        continueFlag = YES;
        break;
      }
    }
    if (continueFlag)
      continue;
    if (resultColors.count < self.count)
      [resultColors addObject:curColor];
    else
      break;
  }
  return [NSArray arrayWithArray:resultColors];
}

@end

@implementation TDCountedColor

- (id)initWithColor:(UIColor *)color count:(NSUInteger)count {
	if ((self = [super init])) {
		self.color = color;
		self.count = count;
	}
	return self;
}

- (NSComparisonResult)compare:(TDCountedColor *)object {
	if ([object isKindOfClass:[TDCountedColor class]]) {
		if (self.count < object.count)
			return NSOrderedDescending;
		else if (self.count == object.count)
			return NSOrderedSame;
	}
	return NSOrderedAscending;
}


@end
