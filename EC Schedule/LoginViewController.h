//
//  LoginViewController.h
//  EC Schedule
//
//  Created by Matti Mühlemann on 4/20/14.
//  Copyright (c) 2014 Matti Mühlemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaterialTextField/MaterialTextField.h>
#import <AFNetworking/AFNetworking.h>
#import "JTAlertView.h"

@interface LoginViewController : UIViewController
{   
    MFTextField *username;
    MFTextField *password;
    UIButton *submitBtn;
}

@end
