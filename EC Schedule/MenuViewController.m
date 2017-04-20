//
//  MenuViewController.m
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/25/15.
//  Copyright © 2015 Matti Mühlemann. All rights reserved.
//

#import "MenuViewController.h"
#import "Constants.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize station;
@synthesize menu;

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
    [attributes setObject:[UIFont fontWithName:@"Avenir" size:21.0] forKey:NSFontAttributeName];
    [attributes setObject:COL_NAVTEXT forKey:NSForegroundColorAttributeName];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 63)];
    [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:station]]];
    [navBar setBarTintColor:COL_NAVBAR];
    [navBar setTitleTextAttributes:attributes];
    [self.view addSubview:navBar];

    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(5, 17, 30, 40)];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitle:@"‹" forState:UIControlStateNormal];
    [btnBack setTitleColor:COL_NAVTEXT forState:UIControlStateNormal];
    [btnBack.titleLabel setFont:[UIFont systemFontOfSize:40]];
    [navBar addSubview:btnBack];
    
    UITableView *tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 64 - 50)];
    [tblView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tblView setBackgroundColor:[UIColor clearColor]];
    [tblView setLayoutMargins:UIEdgeInsetsZero];
    [tblView setDelegate:self];
    [tblView setDataSource:self];
    [self.view addSubview:tblView];
}

/**
 * Numbers of Sections
 *
 * @param tableView
 * @return NSIntiger
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

/**
 * Title for Section
 *
 * @param section
 * @param tableView
 * @return NSString
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [@[@"BREAKFAST", @"LUNCH", @"DINNER"] objectAtIndex:section];
}

/**
 * View for the section header
 *
 * @param tableView
 * @param view
 * @param section
 */
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
    [tableViewHeaderFooterView.textLabel setFont:[UIFont fontWithName:@"Avenir" size:12.0]];
    [tableViewHeaderFooterView.contentView setBackgroundColor:COL_BG];
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
    return [[menu objectForKey:[@[@"breakfast", @"lunch", @"dinner"] objectAtIndex:section]] count];
}

/**
 * Hight for Row
 *
 * @param tableView
 * @param indexPath
 * @return CGFloat
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Get text
    NSString *title = [@[@"breakfast", @"lunch", @"dinner"] objectAtIndex:indexPath.section];
    NSString *text  = [[[menu objectForKey:title] objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    // Calculate detail label size
    CGSize constraint = CGSizeMake(VIEW_WIDTH - 30, CGFLOAT_MAX);
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:12.0]};
    CGRect size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    
    return 40 + size.size.height;
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
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir" size:12.0]];
        [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.detailTextLabel setNumberOfLines:0];
    }
    
    // Load the cell data
    NSString *title = [@[@"breakfast", @"lunch", @"dinner"] objectAtIndex:indexPath.section];
    [cell.textLabel       setText:[[[menu objectForKey:title] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cell.detailTextLabel setText:[[[menu objectForKey:title] objectAtIndex:indexPath.row] objectForKey:@"description"]];
    
    return cell;
}

/**
 * Manages cell selection
 *
 * @param tableView
 * @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 * Pops the view from the stack
 *
 */
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
