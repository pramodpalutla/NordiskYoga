//
//  SongsIAPHelper.h
//  Nordisk Yoga
//
//  Created by Nguyen Trung Thanh on 12/18/14.
//  Copyright (c) 2014 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import "IAPHelper.h"

@interface SongsIAPHelper : IAPHelper

+ (SongsIAPHelper *)sharedInstance;
+(void)setProductIds:(NSArray*)prodIDS;

@end
