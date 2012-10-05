//
//  MainViewController.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HostViewController.h"
#import "JoinViewController.h"

@interface MainViewController : BaseViewController<HostViewControllerDelegate,JoinViewControllerDelegate>

@property(nonatomic,strong) UIButton *hostgameBtn;
@property(nonatomic,strong) UIButton *joingameBtn;
@property(nonatomic,strong) UIButton *singlePlayerBtn;

@property(nonatomic,strong) UICard *xCard;
@property(nonatomic,strong) UICard *uCard;
@property(nonatomic,strong) UICard *hCard;
@property(nonatomic,strong) UICard *aCard;
@property(nonatomic,strong) UICard *oCard;

- (void)doClickHostGame:(id)sender;
- (void)doClickJoinGame:(id)sender;
- (void)doClickSinglePlay:(id)sender;

@end
