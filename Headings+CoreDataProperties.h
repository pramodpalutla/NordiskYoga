//
//  Headings+CoreDataProperties.h
//  
//
//  Created by Snehal Machan on 7/19/18.
//
//

#import "Headings+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Headings (CoreDataProperties)

+ (NSFetchRequest<Headings *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *heading;
@property (nonatomic) int16_t page;

@end

NS_ASSUME_NONNULL_END
