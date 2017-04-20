//
//  Menu.m
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/24/15.
//  Copyright © 2015 Matti Mühlemann. All rights reserved.
//

#import "Menu.h"

@implementation Menu

@synthesize date;
@synthesize menu;

/**
 * Initializes the class
 *
 * @param responseObject
 * @return self
 */
- (id)initWithObject:(id)responseObject
{
    self = [super init];
    if (self)
    {
        date = [responseObject objectForKey:@"date"];
        menu = [responseObject objectForKey:@"menu"];
    }
    
    return self;
}

/**
 * Sorts the menu
 *
 * @param searchTerm
 * @return dictionary
 */
- (NSDictionary *)getMenuFor:(NSString *)searchTerm
{
    // Sort for stations
    NSArray *filterd   = [menu filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.station == [c] %@", searchTerm]];
    
    NSLog(@"%@", filterd);
    
    // Sort for type
    NSArray *breakfast = [filterd filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type == [c] 'Breakfast'"]];
    NSArray *lunch     = [filterd filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type == [c] 'Lunch'"]];
    NSArray *dinner    = [filterd filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type == [c] 'Dinner'"]];
    
    return @{@"breakfast" : breakfast, @"lunch" : lunch, @"dinner" : dinner};
}

@end
