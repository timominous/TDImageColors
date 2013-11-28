//
//  TDDemoViewController.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "TDDemoViewController.h"
#import "TDImageColors.h"

@interface TDDemoViewController ()

@end

@implementation TDDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  dispatch_group_t group = dispatch_group_create();
  
  dispatch_group_enter(group);
  UIImage *image = [UIImage imageNamed:@"test_image.jpg"];
  TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:image count:5];
  dispatch_group_leave(group);
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    for (UIColor *color in imageColors.colors) {
      NSUInteger idx = [imageColors.colors indexOfObject:color];
      [_colorViews[idx] setBackgroundColor:color];
    }
  });
}

@end
