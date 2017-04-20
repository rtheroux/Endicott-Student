//
//  LoginViewController.m
//  EC Schedule
//
//  Created by Matti Mühlemann on 4/20/14.
//  Copyright (c) 2014 Matti Mühlemann. All rights reserved.
//

#import "LoginViewController.h"
#import "ScheduleViewController.h"
#import "Constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

/**
 * First function to run when the view starts.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:COL_BG];
    
    // Add a nav bar
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[UIFont fontWithName:@"Avenir" size:20.0] forKey:NSFontAttributeName];
    [attributes setObject:COL_NAVTEXT forKey:NSForegroundColorAttributeName];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 63)];
    [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Schedule"]]];
    [navBar setBarTintColor:COL_NAVBAR];
    [navBar setTitleTextAttributes:attributes];
    [self.view addSubview:navBar];
    
    username = [[MFTextField alloc] initWithFrame:CGRectMake(20, 90, VIEW_WIDTH - 40, 40)];
    [username setPlaceholder:@"Student ID or Email"];
    [username setTintColor:COL_GREEN];
    [username setClearButtonMode:UITextFieldViewModeWhileEditing];
    [username setKeyboardType:UIKeyboardTypeEmailAddress];
    [username setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.view addSubview:username];
    
    password = [[MFTextField alloc] initWithFrame:CGRectMake(20, 160, VIEW_WIDTH - 40, 40)];
    [password setPlaceholder:@"Password"];
    [password setTintColor:COL_GREEN];
    [password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [password setSecureTextEntry:YES];
    [self.view addSubview:password];
    
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 230, VIEW_WIDTH - 40, 40)];
    [submitBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    
    // Save enterd info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"username"] != NULL && [defaults objectForKey:@"password"] != NULL)
    {
        [username setText:[NSString stringWithFormat:@"%@", [defaults objectForKey:@"username"]]];
        [password setText:[NSString stringWithFormat:@"%@", [defaults objectForKey:@"password"]]];
    }
}

/**
 * Saves the login information and switches views.
 *
 */
- (void)login
{
    // Reset the login feilds
    [submitBtn setTitle:@"LOGGING IN 👌" forState:UIControlStateNormal];
    
    // Create the post
    NSURL *postURL = [NSURL URLWithString:@"https://cars.endicott.edu/cgi-bin/public/genform/iosauth.cgi"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];

    NSString *postString = [NSString stringWithFormat:@"signinusername=%@&signinpassword=%@", username.text, password.text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postString forHTTPHeaderField:@"Content-Length"];
    
    // Make the request to the server
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        // The Initial Server Responses.
        NSString *serverStatus = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        NSArray *responses = [serverStatus componentsSeparatedByString:@"}{"];

        if ([[responses objectAtIndex:0] rangeOfString:@"ERROR"].location == NSNotFound)
        {
            [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:@"password"];

            NSData *response = [[NSString stringWithFormat:@"{%@", [responses objectAtIndex:1]] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *classes = [NSJSONSerialization JSONObjectWithData:response  options:kNilOptions error:nil];
            ScheduleViewController *vc = [[ScheduleViewController alloc] init];
            [vc setClasses:classes];

            [self.navigationController pushViewController:vc animated:NO];

            [submitBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
            [username resignFirstResponder];
            [password resignFirstResponder];
        }
        else
        {
            [self loginDisrupted:@"The login failed. Please make sure that your credentials are correct."];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self loginDisrupted:@"Something went wrong 😟 Please make sure that you are conected to the internet."];
    }];
    [operation start];
}

/**
 * Alert message incase the login fails
 *
 * @param title
 */
- (void)loginDisrupted:(NSString *)title
{
    // Reset login button text
    [submitBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
    
    // Alert with random alert Image
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%d", RAND_FROM_TO(1, ALERT_IMG_COUNT)]];
    JTAlertView *alert = [[JTAlertView alloc] initWithTitle:title andImage:img];
    [alert setSize:CGSizeMake(VIEW_WIDTH - 40, 230)];
    [alert setFont:[UIFont fontWithName:@"Avenir" size:16]];
    [alert setBackgroundShadow:YES];
    [alert addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    [alert show];
}

/**
 * Handles all memory warnings.
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
