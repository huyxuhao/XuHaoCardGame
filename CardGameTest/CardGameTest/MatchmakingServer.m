//
//  MatchmakingServer.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "MatchmakingServer.h"

typedef enum {
    ServerStateIdle,
    ServerStateAcceptConnections,
    ServerStateIgnoringNewConnections,
}
ServerState;

@implementation MatchmakingServer{
    ServerState serverState;
}
@synthesize maxClients, connectedClieent,session;
@synthesize delegate;

- (id)init{
    if(self = [super init]){
        serverState = ServerStateIdle;
    }    
    return self;
}

#pragma mark Public methods
- (void)startAcceptingConnectionsForSeesionID:(NSString *)sessionId{
    if(serverState ==  ServerStateIdle){
        serverState = ServerStateAcceptConnections;
        self.connectedClieent = [NSMutableArray arrayWithCapacity:self.maxClients];
        self.session = [[GKSession alloc] initWithSessionID:sessionId displayName:nil sessionMode:GKSessionModeServer];
        self.session.delegate = self;
        self.session.available =YES;
    }    
}
- (void)stopAcceptingConnections{
    NSAssert(serverState == ServerStateAcceptConnections, @"Wrong state");
    
    serverState = ServerStateIgnoringNewConnections;
    self.session.available = NO;
}
- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index
{
	return [connectedClieent objectAtIndex:index];
}

- (NSString *)displayNameForPeerID:(NSString *)peerID
{
	return [self.session displayNameForPeer:peerID];
}
#pragma mark GKSession Delegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);
#endif
    
    switch (state) {
        case GKPeerStateAvailable:            
            break;
        case GKPeerStateUnavailable:
            break;
            // A new client has connected to the server.
		case GKPeerStateConnected:
			if (serverState == ServerStateAcceptConnections)
			{
				if (![self.connectedClieent containsObject:peerID])
				{
					[self.connectedClieent addObject:peerID];
#ifdef DEBUG
                    NSLog(@"Connected Client : %@",self.connectedClieent);
#endif
					[self.delegate matchmakingServer:self clientDidConnect:peerID];
				}
			}
			break;
            
            // A client has disconnected from the server.
		case GKPeerStateDisconnected:
			if (serverState != ServerStateIdle)
			{
				if ([self.connectedClieent containsObject:peerID])
				{
					[self.connectedClieent removeObject:peerID];
					[self.delegate matchmakingServer:self clientDidDisconnect:peerID];
				}
			}
			break;
            
		case GKPeerStateConnecting:
			break;
    }
}
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: connection request from peer %@", peerID);
#endif
    
    if(serverState == ServerStateAcceptConnections && [self.connectedClieent count] < self.maxClients){
        NSError *error;
        if([self.session acceptConnectionFromPeer:peerID error:&error]){
#ifdef DEBUG
            NSLog(@"MatchmakingServer: Connection accepted from peer %@", peerID);
#endif
        }else {
#ifdef DEBUG
            NSLog(@"MatchmakingServer: Error accepting connection from peer %@, %@", peerID, error);
#endif
        }
    }else {
        [self.session denyConnectionFromPeer:peerID];
    }
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
