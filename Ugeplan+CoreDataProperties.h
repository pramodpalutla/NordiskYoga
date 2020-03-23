//
//  Ugeplan+CoreDataProperties.h
//  
//
//  Created by Snehal Machan on 7/19/18.
//
//

#import "Ugeplan+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Ugeplan (CoreDataProperties)

+ (NSFetchRequest<Ugeplan *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *data;
@property (nonatomic) int16_t iD;
@property (nullable, nonatomic, copy) NSString *next_heading;
@property (nullable, nonatomic, copy) NSString *prev_heading;

@end

NS_ASSUME_NONNULL_END
