//
//  HostViewController.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "BaseViewController.h"

@class HostViewController;
@protocol HostViewControllerDelegate <NSObject>

- (void)hostViewControllerDidCancel:(HostViewController*)controller;
- (void)hostViewController:(HostViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;

@end

@interface HostViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,MatchmakingServerDelegate>

@property(nonatomic, strong) UILabel *headingLb;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UITextField *nameTf;
@property(nonatomic, strong) UILabel *statusLb;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *startButton;
@property(nonatomic, strong) UIButton *exitButton;
@property(nonatomic, unsafe_unretained) id<HostViewControllerDelegate> delegate;

- (void)doClickStart:(id)sender;
- (void)doClickExit:(id)sender;

@end
