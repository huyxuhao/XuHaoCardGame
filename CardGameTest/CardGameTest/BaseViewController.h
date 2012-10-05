//
//  BaseViewController.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICard.h"
#import "UIFont+SnapAdditions.h"
#import "MatchmakingServer.h"
#import "MatchingmakingClient.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kHeadingLbFrame CGRectMake(115, 11, 250, 27)
#define kNameLbFrame CGRectMake(72, 53, 96, 20)
#define kNameTfFrame CGRectMake(172, 51 , 230, 30)
#define kStatusLbFrame CGRectMake(83, 90, 313, 27)
#define kTableViewFrame CGRectMake(22, 122, 440, 132)
#define kStartBtnFrame CGRectMake(157, 273, 165, 37)
#define kExitBtnFrame CGRectMake(5, 276, 33, 33)

@interface BaseViewController : UIViewController

@end
