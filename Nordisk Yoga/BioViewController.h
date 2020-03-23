//
//  BioViewController.h
//  Nordisk Yoga
//
//  Created by Nguyen Trung Thanh on 12/22/14.
//  Copyright (c) 2014 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface BioViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;

@property (strong, nonatomic) IBOutlet UITableView *ugView;
@property (nonatomic)AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
