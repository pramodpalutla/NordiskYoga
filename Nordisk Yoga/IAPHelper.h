//
//  IAPHelper.h
//  Nordisk Yoga
//
//  Created by Nguyen Trung Thanh on 12/18/14.
//  Copyright (c) 2014 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
+(void)restorePurchases:(UIActivityIndicatorView *)indicator :(UIButton*)butt;

@end
