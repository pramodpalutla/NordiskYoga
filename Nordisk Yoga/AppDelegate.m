

#import "AppDelegate.h"
#import "About+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [NSThread sleepForTimeInterval:5.0];

    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    persistentContainer = [self persistentContainer];

    return YES;
}

-(About *)createAbout{
//    NSManagedObjectContext *context =self.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    About *newObject = [NSEntityDescription
                          insertNewObjectForEntityForName:@"About"
                          inManagedObjectContext:context];
    return newObject;
}
-(Headings *)createHeading{
//    NSManagedObjectContext *context =self.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self managedObjectContext];

    Headings *newObject = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Headings"
                        inManagedObjectContext:context];
    return newObject;
}
-(Om*)createOm{
//    NSManagedObjectContext *context =self.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self managedObjectContext];

    Om *newObject = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Om"
                        inManagedObjectContext:context];
    return newObject;
}
-(Ugeplan*)createUgeplan{
    //    NSManagedObjectContext *context =self.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Ugeplan *newObject = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Ugeplan"
                     inManagedObjectContext:context];
    return newObject;
}
-(Programmer *)createProgrammer{
    //    NSManagedObjectContext *context =self.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Ugeplan *newObject = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Programmer"
                          inManagedObjectContext:context];
    return newObject;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Core Data stack for ios 10.0 below


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"coreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
