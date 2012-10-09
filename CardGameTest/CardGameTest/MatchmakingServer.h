//
//  MatchmakingServer.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
@class MatchmakingServer;
@protocol MatchmakingServerDelegate <NSObject>

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID;
- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID;
- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server;
- (void)matchmakingServerNoNetwork:(MatchmakingServer *)server;

@end

@interface MatchmakingServer : NSObject<GKSessionDelegate>

@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong) NSMutableArray *connectedClieent;
@property (nonatomic, strong) GKSession *session;
@property (nonatomic, unsafe_unretained) id<MatchmakingServerDelegate> delegate;
- (void)startAcceptingConnectionsForSeesionID:(NSString*) sessionId;
- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;
- (void)endSession;
@end
