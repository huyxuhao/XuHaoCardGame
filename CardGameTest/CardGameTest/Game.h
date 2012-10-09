//
//  Game.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/9/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <GameKit/GameKit.h>

@class Game;
@protocol GameDelegate <NSObject>

- (void)game:(Game*)game didQuitWithReason:(QuitReason)reason;
- (void)gameWaitingForServerReady:(Game *)game;

@end

@interface Game : NSObject<GKSessionDelegate>

@property (nonatomic,assign) BOOL isServer;
@property (nonatomic,unsafe_unretained) id<GameDelegate> delegate;

- (void)startClientGameWithSession:(GKSession *)gkSession playerName:(NSString *)name server:(NSString *)peerID;
- (void)quitGameWithReason:(QuitReason)reason;

@end
