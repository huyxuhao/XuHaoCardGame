//
//  MatchingmakingClient.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class MatchingmakingClient;

@protocol MatchingmakingClientDelegate <NSObject>

- (void)MatchingmakingClient:(MatchingmakingClient*)client serverBecameAvailable:(NSString*)peerID;
- (void)MatchingmakingClient:(MatchingmakingClient*)client serverBecameUnAvailable:(NSString*)peerID;


@end

@interface MatchingmakingClient : NSObject<GKSessionDelegate>

@property (nonatomic, strong) NSMutableArray *availableServers;
@property (nonatomic, strong) GKSession *session;
@property (nonatomic, unsafe_unretained) id<MatchingmakingClientDelegate> delegate;

- (void)startSearchingForServersWithSessionID:(NSString*)sessionID;
- (NSString*)peerIDForAvailableServerAtIndex:(NSUInteger)index;
- (NSString*)displayNameForPeerId:(NSString*)peerID;

@end
