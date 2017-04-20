//
//  ScheduleViewController.h
//  EC Schedule
//
//  Created by Matti Mühlemann on 4/16/14.
//  Copyright (c) 2014 Matti Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "JTAlertView.h"

@interface ScheduleViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
{
    BOOL firstRun;
    
    UINavigationBar *navBar;
    UIScrollView *scroll;
}

@property (nonatomic, retain) NSDictionary *classes;

@end