//
//  SettingsViewController.m
//  EC Schedule
//
//  Created by Matti Muehlemann on 12/29/15.
//  Copyright © 2015 Matti Mühlemann. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

/**
 * Sets up and initializes the view.
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
    [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Settings"]]];
    [navBar setBarTintColor:COL_NAVBAR];
    [navBar setTitleTextAttributes:attributes];
    [self.view addSubview:navBar];
    
    UITableView *tblSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 64 - 50)];
    [tblSettings setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tblSettings setBackgroundColor:[UIColor clearColor]];
    [tblSettings setSeparatorColor:[UIColor lightGrayColor]];
    [tblSettings setLayoutMargins:UIEdgeInsetsZero];
    [tblSettings setDelegate:self];
    [tblSettings setDataSource:self];
    [self.view addSubview:tblSettings];
}

/**
 * Numbers of Rows in Section
 *
 * @param tableView
 * @param section
 * @return NSIntiger
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5)
        return 35;
    
    return 60;
}

/**
 * Cell for Row
 *
 * @param tableView
 * @param indexPath
 * @return UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];  
    }
    
    switch (indexPath.row)
    {
        case 1:
            [cell.textLabel setText:@"Tell a friend!"];
            [cell.imageView setImage:[UIImage imageNamed:@"set_share"]];
            break;
        case 3:
            [cell.textLabel setText:@"Endicott on Facebook"];
            [cell.imageView setImage:[UIImage imageNamed:@"set_facebook"]];
            break;
        case 4:
            [cell.textLabel setText:@"Endicott on Twitter"];
            [cell.imageView setImage:[UIImage imageNamed:@"set_twitter"]];
            break;
        case 6:
            [cell.textLabel setText:@"Write a review!"];
            [cell.imageView setImage:[UIImage imageNamed:@"set_review"]];
            break;
        case 7:
            [cell.textLabel setText:@"Icons by icons8.com"];
            [cell.imageView setImage:[UIImage imageNamed:@"set_credit"]];
            break;
        case 8:
            [cell.textLabel setText:[NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
            [cell.imageView setImage:[UIImage imageNamed:@"set_version"]];
            break;
        case 9:
            [cell.textLabel setText:@"Created by Matt Mühlemann"];
            [cell.imageView setImage:[UIImage imageNamed:@"set_author"]];
            break;
        default:
            [cell setBackgroundColor:[UIColor clearColor]];
            break;
    }
    
    return cell;
}

/**
 * Did select Row
 *
 * @param tableView
 * @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 1:
        {
            NSArray *activityItems = @[[NSString stringWithFormat:@"Checkout the Endicott App on the App Store\n\nitms-apps://itunes.apple.com/app/id%@", APP_ID]];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [activityVC setExcludedActivityTypes:@[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]];
            [self presentViewController:activityVC animated:TRUE completion:nil];
        }
            break;
        case 3:
        {
            NSURL *fanPageURL = [NSURL URLWithString:@"fb://page/?id=240303314638"];
            if (![[UIApplication sharedApplication] canOpenURL:fanPageURL])
                fanPageURL = [NSURL URLWithString:@"https://www.facebook.com/EndicottCollege/"];
            
            [[UIApplication sharedApplication] openURL:fanPageURL];
        }
            break;
        case 4:
        {
            NSURL *fanPageURL = [NSURL URLWithString:@"twitter://user?id=20926783"];
            if (![[UIApplication sharedApplication] canOpenURL:fanPageURL])
                fanPageURL = [NSURL URLWithString:@"https://twitter.com/EndicottCollege"];
            
            [[UIApplication sharedApplication] openURL:fanPageURL];
        }
            break;
        case 6:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APP_ID]]];
            break;
        case 7:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://icons8.com"]];
            break;
        default:
            break;
    }
}

/**
 * Manages memory warnings
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
