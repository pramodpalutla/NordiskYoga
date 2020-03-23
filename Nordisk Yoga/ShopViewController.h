//
//  ShopViewController.h
//  Nordisk Yoga
//
//  Created by Nguyen Trung Thanh on 12/3/14.
//  Copyright (c) 2014 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ShopViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UITextView *lblDes;
@property (nonatomic)AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIView *outerview;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
