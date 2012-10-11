//
//  Game.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/9/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "Player.h"
#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"

@class Game;
@protocol GameDelegate <NSObject>

- (void)game:(Game*)game didQuitWithReason:(QuitReason)reason;
- (void)gameWaitingForServerReady:(Game *)game;
- (void)gameWaitingForClientsReady:(Game *)game;

@end

@interface Game : NSObject<GKSessionDelegate>

@property (nonatomic,assign) BOOL isServer;
@property (nonatomic,unsafe_unretained) id<GameDelegate> delegate;

- (void)startClientGameWithSession:(GKSession *)gkSession playerName:(NSString *)name server:(NSString *)peerID;
- (void)startServerGameWithSession:(GKSession *)gkSession playerName:(NSString *)name clients:(NSArray *)clients;
- (void)quitGameWithReason:(QuitReason)reason;
- (void)sendPacketToAllClients:(Packet *)packet;
- (void)sendPacketToServer:(Packet *)packet;
- (void)clientReceivedPacket:(Packet *)packet;
- (Player *)playerWithPeerID:(NSString *)peerID;
- (void)serverReceivedPacket:(Packet *)packet fromPlayer:(Player *)player;
- (BOOL)receivedResponsesFromAllPlayers;
@end
