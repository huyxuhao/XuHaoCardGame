//
//  MatchingmakingClient.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface MatchingmakingClient : NSObject<GKSessionDelegate>

@property (nonatomic, strong) NSArray *availableServers;
@property (nonatomic, strong) GKSession *session;

- (void)startSearchingForServersWithSessionID:(NSString*)sessionID;

@end
