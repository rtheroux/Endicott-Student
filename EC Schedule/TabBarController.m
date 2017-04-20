//
//  TabBarController.m
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/9/15.
//  Copyright (c) 2015 Matti Mühlemann. All rights reserved.
//

#import "TabBarController.h"
#import "Constants.h"

@implementation TabBarController

- (void)viewDidLoad
{
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setBarTintColor:COL_NAVBAR];
    [self setDelegate:self];
    
    // Change icon pos
    for (UITabBarItem *item in [self.tabBar items]) {
        [item setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
    }
    
    tabIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 3, VIEW_WIDTH / [self.tabBar.items count], 3)];
    [tabIndicatorView setBackgroundColor:COL_GREEN];
    [self.view addSubview:tabIndicatorView];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [UIView animateWithDuration:0.3 animations:^(void){
        [tabIndicatorView setFrame:CGRectMake((VIEW_WIDTH / 3) * tabBarController.selectedIndex, VIEW_HEIGHT - 3, VIEW_WIDTH / 3, 3)];
    }];
}

@end
