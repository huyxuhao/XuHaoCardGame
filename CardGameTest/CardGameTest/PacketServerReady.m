//
//  PacketServerReady.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/11/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "PacketServerReady.h"
#import "Player.h"

@implementation PacketServerReady

@synthesize players;

+ (id)packetWithPlayers:(NSMutableDictionary *)pls{
    return [[[self class] alloc] initWithPlayers:pls];
}

+ (id)packetWithData:(NSData *)data {
    NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:4];
    size_t offset = PACKET_HEADER_SIZE;
    size_t count;
    
    int numberOfPlayers = [data rw_int8AtOffset:offset];
	offset += 1;
    
    for (int t = 0; t < numberOfPlayers; ++t)
	{
		NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
		offset += count;
        
		NSString *name = [data rw_stringAtOffset:offset bytesRead:&count];
		offset += count;
        
		PlayerPosition position = [data rw_int8AtOffset:offset];
		offset += 1;
        
		Player *player = [[Player alloc] init];
		player.peerID = peerID;
		player.name = name;
		player.position = position;
		[players setObject:player forKey:player.peerID];
	}
    
	return [[self class] packetWithPlayers:players];
}

- (id)initWithPlayers:(NSMutableDictionary *)pls{
    if(self = [super initWithType:PacketTypeServerReady]){
        self.players = pls;
    }
    
    return  self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendInt8:[self.players count]];
    
	[self.players enumerateKeysAndObjectsUsingBlock:^(id key, Player *player, BOOL *stop)
     {
         [data rw_appendString:player.peerID];
         [data rw_appendString:player.name];
         [data rw_appendInt8:player.position];
     }];
}

@end
