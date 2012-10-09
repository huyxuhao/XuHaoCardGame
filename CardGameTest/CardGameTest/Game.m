//
//  Game.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/9/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "Game.h"

typedef enum {
    GameStateWaitingForSignIn,
    GameStateWaitingForReady,
    GameStateDealing,
    GameStatePlaying,
    GameStateGameOver,
    GameStateQuitting,
}GameState;

@implementation Game{
    GameState state;
    
    GKSession *session;
    NSString *serverPeerId;
    NSString *localPlayerName;
}
@synthesize delegate, isServer;

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

#pragma mark Private Methods

#pragma mark Public Methods [Game logic]
- (void)startClientGameWithSession:(GKSession *)gkSession playerName:(NSString *)name server:(NSString *)peerID {
    
    self.isServer = NO;
    
	session = gkSession;
	session.available = NO;
	session.delegate = self;
	[session setDataReceiveHandler:self withContext:nil];
    
	serverPeerId = peerID;
	localPlayerName = name;
    
	state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForServerReady:self];
    
}

- (void)quitGameWithReason:(QuitReason)reason{
    state = GameStateQuitting;
    
	[session disconnectFromAllPeers];
	session.delegate = nil;
	session = nil;
    
	[self.delegate game:self didQuitWithReason:reason];
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)gkState
{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, gkState);
#endif
}

- (void)session:(GKSession *)ss didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[ss denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
}

@end
