//
//  Packet.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/10/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

typedef enum {
    PacketTypeSignInRequest = 0x64,    //Server to client
    PacketTypeSiginInResponse,         //client to server
    
    PacketTypeServerReady,             //server to client
    PacketTypeClientReady,             //client to server
    
    PacketTypeDealCards,               // server to client
	PacketTypeClientDealtCards,        // client to server
    
	PacketTypeActivatePlayer,          // server to client
	PacketTypeClientTurnedCard,        // client to server
    
	PacketTypePlayerShouldSnap,        // client to server
	PacketTypePlayerCalledSnap,        // server to client
    
	PacketTypeOtherClientQuit,         // server to client
	PacketTypeServerQuit,              // server to client
	PacketTypeClientQuit,              // client to server
    
    
}PacketType;

@interface Packet : NSObject

@property(nonatomic, assign) PacketType packetType;

+ (id)packetWithType:(PacketType)pkType;
- (id)initWithType:(PacketType)pkType;

- (NSData*)data;

@end
