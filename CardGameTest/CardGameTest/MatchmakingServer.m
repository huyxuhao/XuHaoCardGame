//
//  MatchmakingServer.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "MatchmakingServer.h"

@implementation MatchmakingServer
@synthesize maxClients, connectedClieent,session;



#pragma mark Public methods
- (void)startAcceptingConnectionsForSeesionID:(NSString *)sessionId{
    self.connectedClieent = [NSMutableArray arrayWithCapacity:self.maxClients];
    self.session = [[GKSession alloc] initWithSessionID:sessionId displayName:nil sessionMode:GKSessionModeServer];
    self.session.delegate = self;
    self.session.available =YES;
}
#pragma mark GKSession Delegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);
#endif
}
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: connection with peer %@ failed %@", peerID, error);
#endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: session failed %@", error);
#endif
}

@end
