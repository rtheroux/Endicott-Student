//
//  DiningViewController.m
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/22/14.
//  Copyright (c) 2014 Matti Mühlemann. All rights reserved.
//

#import "DiningViewController.h"
#import "MenuViewController.h"
#import "Constants.h"

@interface DiningViewController ()

@end

@implementation DiningViewController

/**
 * First function to run when the program starts.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:COL_BG];
    
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(20, (VIEW_HEIGHT / 2) - 20, VIEW_WIDTH - 40, 40)];
    [lblLoading setTextAlignment:NSTextAlignmentCenter];
    [lblLoading setTextColor:[UIColor grayColor]];
    [lblLoading setText:@"Loading 🍦"];
    [self.view addSubview:lblLoading];
    
    // Add the blueprint
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 64 - 50)];
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sodexo:ECSodexo01@xn--mhlemann-65a.net/CallahanDining/backend/ios/menu.php"]]];
    [myWebView setBackgroundColor:COL_BG];
    [myWebView.scrollView setScrollEnabled:NO];
    [myWebView setScalesPageToFit:YES];
    [myWebView setMultipleTouchEnabled:NO];
    [myWebView setDelegate:self];
    [myWebView setAlpha:0.0];
    [self.view addSubview:myWebView];
    
    // Add a nav bar
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[UIFont fontWithName:@"Avenir" size:20.0] forKey:NSFontAttributeName];
    [attributes setObject:COL_NAVTEXT forKey:NSForegroundColorAttributeName];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 63)];
    [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Dining"]]];
    [navBar setBarTintColor:COL_NAVBAR];
    [navBar setTitleTextAttributes:attributes];
    [self.view addSubview:navBar];
    
    UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(10, 28, 24, 24)];
    [btnInfo addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
    [btnInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [navBar addSubview:btnInfo];
}

/**
 * Runs when the view appears
 *
 * @param animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    // Load the webview again
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sodexo:ECSodexo01@xn--mhlemann-65a.net/CallahanDining/backend/ios/menu.php"]]];
    
    // Get the date
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *date = [df stringFromDate:[NSDate date]];
    
    // Make the post request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://sodexo:ECSodexo01@xn--mhlemann-65a.net/CallahanDining/backend/get-menu.php" parameters:@{@"date" : date} success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", manager );
        menu = [[Menu alloc] initWithObject:responseObject];
        
        NSLog(@"%@", responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        // Alert with random alert Image
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%d", RAND_FROM_TO(1, ALERT_IMG_COUNT)]];
        JTAlertView *alert = [[JTAlertView alloc] initWithTitle:@"Something went wrong 😟 Please make sure that you are conected to the internet." andImage:img];
        [alert setSize:CGSizeMake(VIEW_WIDTH - 40, 230)];
        [alert setFont:[UIFont fontWithName:@"Avenir" size:16]];
        [alert setBackgroundShadow:YES];
        [alert addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
            [alertView hide];
        }];
        [alert show];
    }];
}

- (void)info
{
    // Alert with random alert Image
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%d", RAND_FROM_TO(1, ALERT_IMG_COUNT)]];
    JTAlertView *alert = [[JTAlertView alloc] initWithTitle:@"Tap a station to view the menu of the day for that station." andImage:img];
    [alert setSize:CGSizeMake(VIEW_WIDTH - 40, 230)];
    [alert setFont:[UIFont fontWithName:@"Avenir" size:16]];
    [alert setBackgroundShadow:YES];
    [alert addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    [alert show];
}

/**
 * WebView should start loading
 *
 * @param webView
 * @param request
 * @param navigationType
 * @return BOOL
 */
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request URL].absoluteString;
    
    NSLog(@"Hello");    
    
    if ([url isEqualToString:@"http://sodexo:ECSodexo01@xn--mhlemann-65a.net/CallahanDining/backend/ios/menu.php"])
    {
        return YES;
    }
    else
    {
        // Format the url
        NSString *searchTerm = [[url stringByReplacingOccurrencesOfString:@"\%20" withString:@" "] componentsSeparatedByString:@"#"][1];
        searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        [self loadDetailView:searchTerm];
        
        return NO;
    }
}

/**
 * The webview did finish loading
 *
 * @param webView
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView animateWithDuration:0.5
                     animations:^(void){
        [webView setAlpha:1.0];
    }];
}

/**
 * Pushes the next view controller
 *
 * @param searchTerm
 */
- (void)loadDetailView:(NSString *)searchTerm
{
    NSLog(@"%@", searchTerm);
    
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    [menuVC setStation:searchTerm];
    [menuVC setMenu:[menu getMenuFor:searchTerm]];
    
    [self.navigationController pushViewController:menuVC animated:YES];
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
