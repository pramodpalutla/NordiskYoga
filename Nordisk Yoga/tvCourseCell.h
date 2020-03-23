//
//  tvCourseCell.h
//  Nordisk Yoga
//
//  Created by Snehal Machan on 7/6/18.
//  Copyright © 2018 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tvCourseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;

@end
