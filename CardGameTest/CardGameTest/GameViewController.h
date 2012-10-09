//
//  GameViewController.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/9/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "BaseViewController.h"
#import "Game.h"

@class GameViewController;
@protocol GameViewControllerDelegate <NSObject>

- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason;

@end

@interface GameViewController  : BaseViewController <UIAlertViewDelegate, GameDelegate>

@property (nonatomic,strong) UILabel *centerLb;
@property (nonatomic,strong) UIButton *exitButton;

@property (nonatomic, strong) Game *game;
@property (nonatomic, unsafe_unretained) id<GameViewControllerDelegate> delegate;

- (void)doClickExit:(id)sender;

@end
