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
    
    NSMutableDictionary *players;
}
@synthesize delegate, isServer;

- (id)init{
    if((self = [super init])){
        players = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    
    return self;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

#pragma mark Private Methods

#pragma mark - Networking

- (void)sendPacketToAllClients:(Packet *)packet
{
	GKSendDataMode dataMode = GKSendDataReliable;
	NSData *data = [packet data];
	NSError *error;
	if (![session sendDataToAllPeers:data withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to clients: %@", error);
	}
}

- (void)sendPacketToServer:(Packet *)packet{
    GKSendDataMode dataMode = GKSendDataReliable;
    NSData *data =  [packet data];
    NSError *error;
    
    if (![session sendData:data toPeers:[NSArray arrayWithObject:serverPeerId] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to server: %@", error);
	}
}

- (void)clientReceivedPacket:(Packet *)packet {
    switch (packet.packetType) {
        case PacketTypeSignInRequest:
			if (state == GameStateWaitingForSignIn)
			{
				state = GameStateWaitingForReady;
				Packet *packet = [PacketSignInResponse packetWithPlayerName:localPlayerName];
				[self sendPacketToServer:packet];
			}
			break;
            
		default:
#ifdef DEBUG
			NSLog(@"Client received unexpected packet: %@", packet);
#endif
			break;
    }
}

- (void)serverReceivedPacket:(Packet *)packet fromPlayer:(Player *)player{
    switch (packet.packetType) {
        case PacketTypeSiginInResponse:
			if (state == GameStateWaitingForSignIn)
			{
				player.name = ((PacketSignInResponse *)packet).playerName;
#ifdef DEBUG          
				NSLog(@"server received sign in from client '%@'", player.name);
#endif
			}
			break;
            
		default:
#ifdef DEBUG
			NSLog(@"Server received unexpected packet: %@", packet);
#endif
			break;
    }
}

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

- (void)startServerGameWithSession:(GKSession *)gkSession playerName:(NSString *)name clients:(NSArray *)clients {
    self.isServer = YES;    
	session = gkSession;
	session.available = NO;
	session.delegate = self;
	[session setDataReceiveHandler:self withContext:nil];
    
	state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForClientsReady:self];
    
    //Create the Player object for the server
    Player *player = [[Player alloc] init];
    player.name  = name;
    player.peerID = session.peerID;
    player.position = PlayerPositionBottom;
    
    //Add a player object for each client
    int index = 0;
    for(NSString *peerID in clients){
        Player *player = [[Player alloc] init];
        player.peerID = peerID;
        [players setObject:player forKey:player.peerID];
        
        if (index == 0){
            player.position = ([clients count] == 1) ? PlayerPositionTop:PlayerPositionLeft;
        }else if(index == 1){
            player.position = PlayerPositionTop;            
        }else {
            player.position = PlayerPositionRight;
        }
        
        index ++;
    }
    
    Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
    [self sendPacketToAllClients:packet];
}

- (void)quitGameWithReason:(QuitReason)reason{
    state = GameStateQuitting;
    
	[session disconnectFromAllPeers];
	session.delegate = nil;
	session = nil;
    
	[self.delegate game:self didQuitWithReason:reason];
}

- (Player*)playerWithPeerID:(NSString *)peerID{
    return [players objectForKey:peerID];
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
    Packet *packet = [Packet packetWithData:data];
    if(packet == nil){
#ifdef DEBUG
        NSLog(@"Invalid packet: %@",data);
        return;
#endif
    }
    
    Player *player = [self playerWithPeerID:peerID];
    
    if(self.isServer){
        [self serverReceivedPacket:packet fromPlayer:player];
    }else{
        [self clientReceivedPacket:packet];
    }
}

@end
