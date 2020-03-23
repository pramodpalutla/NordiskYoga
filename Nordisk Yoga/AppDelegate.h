//
//  AppDelegate.h
//  Nordisk Yoga
//
//  Created by Nguyen Trung Thanh on 10/5/14.
//  Copyright (c) 2014 TNHH Giải pháp Công nghệ Trực tuyến VAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreData/CoreData.h>
#import "About+CoreDataClass.h"
#import "Headings+CoreDataClass.h"
#import "Om+CoreDataClass.h"
#import "Ugeplan+CoreDataClass.h"
#import "Programmer+CoreDataClass.h"

#define FONT_BROWN_REG(s) [UIFont fontWithName:@"Brown-Light" size:s]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSMutableArray *videos;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
-(About *)createAbout;
-(Headings *)createHeading;
-(Om *)createOm;
-(Ugeplan *)createUgeplan;
-(Programmer *)createProgrammer;

@end

