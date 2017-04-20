//
//  Constants.h
//  EC Schedule
//
//  Created by Matti Muehlemann on 9/8/15.
//  Copyright (c) 2015 Matti Mühlemann. All rights reserved.
//

#ifndef EC_Schedule_Constants_h
#define EC_Schedule_Constants_h

// General macros
#define VIEW_WIDTH              [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT             [UIScreen mainScreen].bounds.size.height
#define COL_GREEN               [UIColor colorWithRed:0.00 green:0.53 blue:0.40 alpha:1.0]
#define COL_BLUE                [UIColor colorWithRed:0.05 green:0.19 blue:0.49 alpha:1.0]
#define COL_BG                  [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]
#define COL_NAVBAR              [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]
#define COL_NAVTEXT             [UIColor blackColor]
// App Store macros
#define APP_ID                  @"1072476482"

// JTAlertView macros
#define ALERT_IMG_COUNT         6 // Number of different low-poly images of campus
#define RAND_FROM_TO(min, max)  (min + arc4random_uniform(max - min + 1))

#endif
