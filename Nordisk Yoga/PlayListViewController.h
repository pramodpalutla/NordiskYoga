//
//  PlayListViewController.h
//  Nordisk Yoga
//
//  Created by Nguyen Trung Thanh on 10/16/14.
//  Copyright (c) 2014 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SongTableViewCell.h"
#import "SongTableViewCellTitle.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface PlayListViewController : UIViewController < UITableViewDataSource,AVAudioPlayerDelegate, UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UIView *songViewGradient;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic)AppDelegate *appDelegate;
@property int currPlaying;
@property int currVideoPlaying;
@property BOOL scrubbing;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSMutableArray *videos;
@property (strong, nonatomic) AVPlayerViewController * videoController;
@property (strong, nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UITableView *songsTableView;

@property (weak, nonatomic) IBOutlet UIButton *mRestoreBtn;

- (IBAction)RestorePayment:(id)sender;
@end
