//
//  MatchingmakingClient.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "MatchingmakingClient.h"

@implementation MatchingmakingClient
@synthesize session,availableServers;

#pragma Public methods
- (void)startSearchingForServersWithSessionID:(NSString *)sessionID{
    self.availableServers = [NSMutableArray arrayWithCapacity:0];
    self.session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
    self.session.delegate = self;
    self.session.available = YES;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: peer %@ changed state %d", peerID, state);
#endif
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection with peer %@ failed %@", peerID, error);
#endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: session failed %@", error);
#endif
}


@end
