//
//  Programmer+CoreDataProperties.h
//  
//
//  Created by Snehal Machan on 7/20/18.
//
//

#import "Programmer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Programmer (CoreDataProperties)

+ (NSFetchRequest<Programmer *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *data;

@end

NS_ASSUME_NONNULL_END
