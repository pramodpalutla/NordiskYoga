//
//  About+CoreDataProperties.m
//  
//
//  Created by Snehal Machan on 7/18/18.
//
//

#import "About+CoreDataProperties.h"

@implementation About (CoreDataProperties)

+ (NSFetchRequest<About *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"About"];
}

@dynamic name;
@dynamic text;
@dynamic image;

@end
