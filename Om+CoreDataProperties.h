//
//  Om+CoreDataProperties.h
//  
//
//  Created by Snehal Machan on 7/19/18.
//
//

#import "Om+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Om (CoreDataProperties)

+ (NSFetchRequest<Om *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
