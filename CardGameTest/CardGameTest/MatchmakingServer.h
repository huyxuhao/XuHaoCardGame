//
//  MatchmakingServer.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface MatchmakingServer : NSObject<GKSessionDelegate>

@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong) NSMutableArray *connectedClieent;
@property (nonatomic, strong) GKSession *session;

- (void)startAcceptingConnectionsForSeesionID:(NSString*) sessionId;

@end
