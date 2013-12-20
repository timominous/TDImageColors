//
//  TDDemoViewController.h
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDDemoViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
