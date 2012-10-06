//
//  MatchingmakingClient.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "MatchingmakingClient.h"

typedef enum {
    ClientStateIdle,
    ClientStateSearchingForServers,
    ClientStateConnecting,
    ClientStateConnected,
}
ClientState;

@implementation MatchingmakingClient {
    ClientState clientState;
    NSString *serverPeerID;    
}
@synthesize session,availableServers;
@synthesize delegate;

- (id)init{
    if(self = [super init]){
        clientState = ClientStateIdle;
    }
    
    return self;
}

#pragma Public methods
- (void)startSearchingForServersWithSessionID:(NSString *)sessionID{
    clientState = ClientStateSearchingForServers;
    self.availableServers = [NSMutableArray arrayWithCapacity:0];
    self.session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
    self.session.delegate = self;   
    self.session.available = YES;
}

- (void)connectToServerWithPeerID:(NSString *)peerID{
    NSAssert(clientState == ClientStateSearchingForServers, @"Wrong state");
    
    clientState = ClientStateConnecting;
    serverPeerID = peerID;
    [self.session connectToPeer:peerID withTimeout:self.session.disconnectTimeout];
}

- (NSString*)peerIDForAvailableServerAtIndex:(NSUInteger)index{
    return [self.availableServers objectAtIndex:index];
}

- (NSString*)displayNameForPeerId:(NSString *)peerID{
    return [self.session displayNameForPeer:peerID];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: peer %@ changed state %d", peerID, state);
#endif
    
    //show the server to user
    switch (state) {
        //The client has discovered a new server
        case GKPeerStateAvailable:
            if(clientState == ClientStateSearchingForServers){
                if(![availableServers containsObject:peerID]){
                    [availableServers addObject:peerID];
                    //delegate arising event 4 joinViewController here
                    [self.delegate MatchingmakingClient:self serverBecameAvailable:peerID];
                }
            }            
            break;
            // The client sees that a server goes away.
		case GKPeerStateUnavailable:
            if(clientState == ClientStateSearchingForServers){
                if ([availableServers containsObject:peerID])
                {
                    [availableServers removeObject:peerID];
                    //delegate arising event 4 joinViewController here
                    [self.delegate MatchingmakingClient:self serverBecameUnAvailable:peerID];
                }
                break;
            }			
            
		case GKPeerStateConnected:
			break;
            
		case GKPeerStateDisconnected:
			break;
            
		case GKPeerStateConnecting:
			break;
    }
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
