//
//  JoinViewController.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "BaseViewController.h"

@class JoinViewController;
@protocol JoinViewControllerDelegate <NSObject>

- (void)joinViewControllerDidCancel:(JoinViewController*)controller;

@end

@interface JoinViewController : BaseViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MatchingmakingClientDelegate>

@property(nonatomic, strong) UILabel *headingLb;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UITextField *nameTf;
@property(nonatomic, strong) UILabel *statusLb;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *exitButton;
@property(nonatomic, strong) UIView *waitView;
@property(nonatomic, unsafe_unretained) id<JoinViewControllerDelegate> delegate;
- (void)doClickExit:(id)sender;

@end
