//
//  Programmer+CoreDataProperties.m
//  
//
//  Created by Snehal Machan on 7/20/18.
//
//

#import "Programmer+CoreDataProperties.h"

@implementation Programmer (CoreDataProperties)

+ (NSFetchRequest<Programmer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Programmer"];
}

@dynamic data;

@end
