//
//  Menu.h
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/24/15.
//  Copyright © 2015 Matti Mühlemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

- (id)initWithObject:(id)responseObject;
- (NSDictionary *)getMenuFor:(NSString *)serachTerm;

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSArray *menu;

@end
