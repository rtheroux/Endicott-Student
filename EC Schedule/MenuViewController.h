//
//  MenuViewController.h
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/25/15.
//  Copyright © 2015 Matti Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString *station;
@property NSDictionary *menu;

@end
