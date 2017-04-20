//
//  ScheduleViewController.m
//  EC Schedule
//
//  Created by Matti Mühlemann on 4/16/14.
//  Copyright (c) 2014 Matti Mühlemann. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Constants.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

@synthesize classes;

/**
 * First function to run when the program starts.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:COL_BG];
    
    // Set that it is first run.
    firstRun = true;
    
    // Get current day
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    
    // Add a nav bar
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[UIFont fontWithName:@"Avenir" size:20.0] forKey:NSFontAttributeName];
    [attributes setObject:COL_NAVTEXT forKey:NSForegroundColorAttributeName];
    
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 63)];
    [navBar setBarTintColor:COL_NAVBAR];
    [navBar setTitleTextAttributes:attributes];

    if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Saturday"])
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Monday"]]];
    else if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Sunday"])
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Monday"]]];
    else
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:[formatter stringFromDate:[NSDate date]]]]];
    
    [self.view addSubview:navBar];
    
    // Add a scroll view
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 64 - 50)];
    [scroll setContentSize:CGSizeMake(VIEW_WIDTH * 5, 780)];
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setShowsVerticalScrollIndicator:NO];
    [scroll setDelegate:self];
    [scroll setPagingEnabled:YES];
    [scroll setDirectionalLockEnabled:YES];
    [scroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scroll];
    
    // Add the time seperators
    int x = 0;
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 13; j++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x + 45, j * 60, VIEW_WIDTH - 45, 1)];
            [line setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
            [scroll addSubview:line];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 2 + (j * 60), 40, 10)];
            [timeLabel setTextColor:[UIColor lightGrayColor]];
            [timeLabel setFont:[UIFont fontWithName:@"Avenir" size:10]];
            [timeLabel setTextAlignment:NSTextAlignmentRight];
            
            if (j + 8 < 12)
                [timeLabel setText:[NSString stringWithFormat:@"%d AM", j + 8]];
            else if (j + 8 > 12)
                [timeLabel setText:[NSString stringWithFormat:@"%d PM", j - 4]];
            else
                [timeLabel setText:@"NOON"];
            
            [scroll addSubview:timeLabel];
        }
        
        x += self.view.bounds.size.width;
    }
}

/**
 * Handles when the view appears
 *
 * @param animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    if (firstRun)
    {
        // Get current day
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE"];
        
        // Update the title label
        if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Monday"])
            [scroll setContentOffset:CGPointMake(self.view.bounds.size.width * 0, 0)];
        else if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Tuesday"])
            [scroll setContentOffset:CGPointMake(self.view.bounds.size.width * 1, 0)];
        else if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Wednesday"])
            [scroll setContentOffset:CGPointMake(self.view.bounds.size.width * 2, 0)];
        else if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Thursday"])
            [scroll setContentOffset:CGPointMake(self.view.bounds.size.width * 3, 0)];
        else if ([[formatter stringFromDate:[NSDate date]] isEqualToString:@"Friday"])
            [scroll setContentOffset:CGPointMake(self.view.bounds.size.width * 4, 0)];
        else
            [scroll setContentOffset:CGPointMake(self.view.bounds.size.width * 0, 0)];
        
        // Make class blocks out of the passed information
        NSArray *classNames = [[self.classes objectForKey:@"classes"] allKeys];
        NSDictionary *class;
        
        for (int i = 0; i < [classNames count]; i++)
        {
            class = [[self.classes objectForKey:@"classes"] objectForKey:[classNames objectAtIndex:i]];
            NSArray *days = [[class objectForKey:@"days"] componentsSeparatedByString:@"-"];
            
            for (int j = 0; j < [days count]; j++)
            {
                if ([[days objectAtIndex:j] isEqualToString:@"M"])
                    [self makeBlockAtX:50 + (VIEW_WIDTH * 0) ofTitle:[classNames objectAtIndex:i] withInfo:class];
                else if ([[days objectAtIndex:j] isEqualToString:@"T"])
                    [self makeBlockAtX:50 + (VIEW_WIDTH * 1) ofTitle:[classNames objectAtIndex:i] withInfo:class];
                else if ([[days objectAtIndex:j] isEqualToString:@"W"])
                    [self makeBlockAtX:50 + (VIEW_WIDTH * 2) ofTitle:[classNames objectAtIndex:i] withInfo:class];
                else if ([[days objectAtIndex:j] isEqualToString:@"R"])
                    [self makeBlockAtX:50 + (VIEW_WIDTH * 3) ofTitle:[classNames objectAtIndex:i] withInfo:class];
                else if ([[days objectAtIndex:j] isEqualToString:@"F"])
                    [self makeBlockAtX:50 + (VIEW_WIDTH * 4) ofTitle:[classNames objectAtIndex:i] withInfo:class];
            }
        }
        
        // Set that it is not first run.
        firstRun = false;
    }
}

/**
 * Makes a UI Block that represents a class
 *
 * @param posX
 * @param title
 * @param info
 */
- (void)makeBlockAtX:(int)posX ofTitle:(NSString *)title withInfo:(NSDictionary *)info
{
    int startPixle = [self getPixle:[info objectForKey:@"beg_time"]];
    int endPixle   = [self getPixle:[info objectForKey:@"end_time"]] - startPixle;
    
    UIColor *colView = [self hashForColor:title];
    UIColor *colText = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIView *classBackground = [[UIView alloc] initWithFrame:CGRectMake(posX, startPixle, VIEW_WIDTH - 60, endPixle)];
    [classBackground setBackgroundColor:[UIColor whiteColor]];
    [scroll addSubview:classBackground];
    
    UIView *classBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH - 60, endPixle)];
    [classBlock setBackgroundColor:[colView colorWithAlphaComponent:0.3]];
    [classBackground addSubview:classBlock];
    
    UIView *strongIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, endPixle)];
    [strongIndicator setBackgroundColor:colView];
    [classBlock addSubview:strongIndicator];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, classBlock.bounds.size.width - 20, 20)];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [titleLabel setText:title];
    [titleLabel setTextColor:colText];
    [classBlock addSubview:titleLabel];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, classBlock.bounds.size.width - 20, 20)];
    [locationLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [locationLabel setText:[NSString stringWithFormat:@"%@ %@", [info objectForKey:@"building"], [info objectForKey:@"room"]]];
    [locationLabel setTextColor:colText];
    [locationLabel setTextAlignment:NSTextAlignmentRight];
    [classBlock addSubview:locationLabel];
    
    UIButton *coverButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH - 60, endPixle)];
    [coverButton addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setTitle:[NSString stringWithFormat:@"%@^%@^%@", title, [info objectForKey:@"fac_email"], [info objectForKey:@"fac_name"]] forState:UIControlStateNormal];
    [coverButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [coverButton setBackgroundColor:[UIColor clearColor]];
    [classBlock addSubview:coverButton];
}

/**
 * Gets the pixel corresponding to the time string
 *
 * @param time
 * @return int
 */
- (int)getPixle:(NSString *)time
{
    // Get End Time.
    NSArray *components      = [time componentsSeparatedByString:@":"];
    NSString *endMinStr      = [[components objectAtIndex:1] substringToIndex:2];
    NSString *endDateTimeStr = [[components objectAtIndex:1] substringFromIndex:2];
    
    int pixle = [[components objectAtIndex:0] intValue] * 60;
    pixle = pixle + [endMinStr intValue];
    
    if ([endDateTimeStr isEqualToString:@"p"] && [[components objectAtIndex:0] integerValue] != 12)
        pixle = pixle + (12 * 60);
        
    return pixle - 480;
}

/**
 * Takes a string and returns a UIColor
 *
 * @param string
 * @return UIColor
 */
- (UIColor *)hashForColor:(NSString *)string
{
    unsigned int hash = 0;
    for (int i = 0; i < 6; i++)
        hash = [string characterAtIndex:i] + ((hash << 7) - hash);
    
    NSString *hex = [NSString stringWithFormat:@"#%06x", hash % 0x1000000];
    
    unsigned int c;
    if ([hex characterAtIndex:0] == '#')
        [[NSScanner scannerWithString:[hex substringFromIndex:1]] scanHexInt:&c];
    else
        [[NSScanner scannerWithString:hex] scanHexInt:&c];
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0x00ff00) >> 8)/255.0 blue:(c & 0x0000ff)/255.0 alpha:1.0];
}

/**
 * Checks the position of the scrollView
 *
 * @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == self.view.bounds.size.width * 0)
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Monday"]]];
    else if (scrollView.contentOffset.x == self.view.bounds.size.width * 1)
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Tuesday"]]];
    else if (scrollView.contentOffset.x == self.view.bounds.size.width * 2)
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Wednesday"]]];
    else if (scrollView.contentOffset.x == self.view.bounds.size.width * 3)
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Thursday"]]];
    else if (scrollView.contentOffset.x == self.view.bounds.size.width * 4)
        [navBar setItems:[NSArray arrayWithObject:[[UINavigationItem alloc] initWithTitle:@"Friday"]]];
}

/**
 * Creates a view for notes/emailing the teacher.
 * 
 * @param sender
 */
- (void)sendMail:(UIButton *)btn
{
    // Email Adress
    NSArray *info = [btn.titleLabel.text componentsSeparatedByString:@"^"];
    
    // Compose mail
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setSubject:info[0]];
    [mailController setToRecipients:@[info[1]]];
    [mailController setMessageBody:[NSString stringWithFormat:@"Dear Professor %@,\n\n\n\n\nBest Regards,\n\n", [info[2] componentsSeparatedByString:@","][0]] isHTML:NO];
    [self presentViewController:mailController animated:YES completion:nil];
}

/**
 * Handles all of the possible things that could happen when sending an email.
 *
 * @param controller 
 * @param result     
 * @param error
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
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
