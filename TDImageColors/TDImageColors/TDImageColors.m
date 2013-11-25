//
//  TDImageColors.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "TDImageColors.h"

#define TDIMAGECOLORS_SCALED_SIZE 32

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
  UIColor *backgroundColor = [self findBackroundColorOfImage:image imageColors:&imageColors];
  BOOL darkBackground = [backgroundColor isDarkColor];
  NSMutableArray *finalColors = [NSMutableArray arrayWithObject:backgroundColor];
  [finalColors addObjectsFromArray:[self findImageColors:imageColors backgroundColor:backgroundColor]];
  while (finalColors.count < self.count) {
    if (darkBackground)
      [finalColors addObject:[UIColor whiteColor]];
    else
      [finalColors addObject:[UIColor blackColor]];
  }

  self.colors = [NSArray arrayWithArray:finalColors];
}

- (NSArray *)findImageColors:(NSCountedSet *)imageColors backgroundColor:(UIColor *)backgroundColor {
  NSEnumerator *enumerator = [imageColors objectEnumerator];
	UIColor *curColor = nil;
	NSMutableArray *sortedColors = [NSMutableArray arrayWithCapacity:imageColors.count];
  NSMutableArray *resultColors = [NSMutableArray array];
	BOOL findDarkTextColor = ![backgroundColor isDarkColor];
  
  while ((curColor = [enumerator nextObject]) != nil) {
    curColor = [curColor colorWithMinimumSaturation:0.15f];
    if ([curColor isDarkColor] == findDarkTextColor) {
      NSUInteger colorCount = [imageColors countForObject:curColor];
      [sortedColors addObject:[[TDCountedColor alloc] initWithColor:curColor count:colorCount]];
    }
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
    if (resultColors.count < self.count - 1)
      [resultColors addObject:curColor];
    else
      break;
  }
  return [NSArray arrayWithArray:resultColors];
}

- (UIColor *)findBackroundColorOfImage:(UIImage *)image imageColors:(NSCountedSet **)colors {
  size_t width = CGImageGetWidth(image.CGImage);
  size_t height = CGImageGetHeight(image.CGImage);
  
  NSCountedSet *imageColors = [[NSCountedSet alloc] initWithCapacity:width * height];
  NSCountedSet *leftEdgeColors = [[NSCountedSet  alloc] initWithCapacity:height];
  
  for (NSUInteger x = 0; x < width; x++) {
    for (NSUInteger y = 0; y < height; y++) {
      UIColor *color = [UIImage colorFromImage:image atX:x andY:y];
      if (x == 0)
        [leftEdgeColors addObject:color];
      [imageColors addObject:color];
    }
  }
  
  *colors = imageColors;
  
  NSEnumerator *enumerator = [leftEdgeColors objectEnumerator];
  UIColor *curColor = nil;
  NSMutableArray *sortedColors = [NSMutableArray arrayWithCapacity:leftEdgeColors.count];
  
  while ((curColor = [enumerator nextObject]) != nil) {
    NSUInteger colorCount = [leftEdgeColors countForObject:curColor];
    NSInteger randomColorsThreshold = (NSInteger)(height * kColorThresholdMinimumPercentage);
    if (colorCount < randomColorsThreshold)
      continue;
    [sortedColors addObject:[[TDCountedColor alloc] initWithColor:curColor count:colorCount]];
  }
  
  [sortedColors sortUsingSelector:@selector(compare:)];
  
  TDCountedColor *proposedBackgroundColor = nil;
  
  if (sortedColors.count > 0) {
    proposedBackgroundColor = sortedColors[0];
    if ([proposedBackgroundColor.color isBlackOrWhite]) {
      for (NSInteger i = 1; i < sortedColors.count; i++) {
        TDCountedColor *nextProposed = sortedColors[i];
        if (((double)nextProposed.count / (double)proposedBackgroundColor.count) > 0.3f) {
          if (![nextProposed.color isBlackOrWhite]) {
            proposedBackgroundColor = nextProposed;
            break;
          }
        } else {
          break;
        }
      }
    }
  }
  
  return proposedBackgroundColor.color;
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
