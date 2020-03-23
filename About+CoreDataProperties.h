//
//  About+CoreDataProperties.h
//  
//
//  Created by Snehal Machan on 7/18/18.
//
//

#import "About+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface About (CoreDataProperties)

+ (NSFetchRequest<About *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, retain) NSData *image;

@end

NS_ASSUME_NONNULL_END
