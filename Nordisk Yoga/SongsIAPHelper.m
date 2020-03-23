
#import "SongsIAPHelper.h"

@implementation SongsIAPHelper

static NSArray * productIdentifiers1;


+ (SongsIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static SongsIAPHelper * sharedInstance;

    dispatch_once(&once, ^{
        NSSet *Set = [NSSet setWithArray:productIdentifiers1];
        NSSet * productIdentifiers = Set;
                                     
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
+(void)setProductIds:(NSArray*)prodIDS{
    productIdentifiers1 = prodIDS;
}
@end
