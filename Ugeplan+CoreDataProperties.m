//
//  Ugeplan+CoreDataProperties.m
//  
//
//  Created by Snehal Machan on 7/19/18.
//
//

#import "Ugeplan+CoreDataProperties.h"

@implementation Ugeplan (CoreDataProperties)

+ (NSFetchRequest<Ugeplan *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Ugeplan"];
}

@dynamic data;
@dynamic iD;
@dynamic next_heading;
@dynamic prev_heading;

@end
