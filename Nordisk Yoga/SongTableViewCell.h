//
//  SongTableViewCell.h
//  Nordisk Yoga
//
//  Created by Nguyen Duc Ngoc on 9/10/15.
//  Copyright (c) 2015 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSongTitle;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *btnLock;
@property (strong, nonatomic) IBOutlet UIImageView *btnPlay;
@property (strong, nonatomic) IBOutlet UIImageView *imgMediaType;

@end
