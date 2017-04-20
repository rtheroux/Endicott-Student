//
//  DiningViewController.h
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/22/14.
//  Copyright (c) 2014 Matti Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "JTAlertView.h"
#import "Menu.h"

@interface DiningViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *myWebView;
    Menu *menu;
}

@end