//
//  Om+CoreDataProperties.m
//  
//
//  Created by Snehal Machan on 7/19/18.
//
//

#import "Om+CoreDataProperties.h"

@implementation Om (CoreDataProperties)

+ (NSFetchRequest<Om *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Om"];
}

@dynamic text;

@end
