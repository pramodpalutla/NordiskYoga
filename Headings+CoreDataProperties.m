//
//  Headings+CoreDataProperties.m
//  
//
//  Created by Snehal Machan on 7/19/18.
//
//

#import "Headings+CoreDataProperties.h"

@implementation Headings (CoreDataProperties)

+ (NSFetchRequest<Headings *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Headings"];
}

@dynamic heading;
@dynamic page;

@end
