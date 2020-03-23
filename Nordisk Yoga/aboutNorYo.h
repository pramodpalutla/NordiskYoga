//
//  aboutNorYo.h
//  Nordisk Yoga
//
//  Created by Snehal Machan on 7/2/18.
//  Copyright © 2018 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface aboutNorYo : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;

@property (strong, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic)AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
