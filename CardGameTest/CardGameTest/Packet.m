//
//  Packet.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/10/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"

const size_t PACKET_HEADER_SIZE = 10;

@implementation Packet
@synthesize packetType;

+ (id)packetWithType:(PacketType)pkType{
    return  [[[self class] alloc] initWithType:pkType];
}

+ (id)packetWithData:(NSData *)data {
    
    //check length of packet
    if([data length] < PACKET_HEADER_SIZE){
#ifdef DEBUG
        NSLog(@"Error: packet too small");
        return nil;
#endif
    }
    
    //check header of packet
    if([data rw_int32AtOffset:0] != 'SNAP'){
#ifdef DEBUG
        NSLog(@"Error: packet has invalid header");
        return nil;
#endif
        return nil;
    }
    
    int packetNumber = [data rw_int32AtOffset:4];
    PacketType packetType = [data rw_int16AtOffset:8];
    
    Packet *packet;
    switch (packetType)
	{
		case PacketTypeSignInRequest:
			packet = [Packet packetWithType:packetType];
			break;
            
		case PacketTypeSiginInResponse:
			packet = [PacketSignInResponse packetWithData:data];
			break;
            
        case PacketTypeServerReady:
            packet = [PacketServerReady packetWithData:data];
            break;
		default:
#ifdef DEBUG
			NSLog(@"%@ Error: Packet has invalid type",self);
#endif
			return nil;
	}
    
	return packet;
}

- (id)initWithType:(PacketType)pkType{
    if(self = [super init]){
        self.packetType = pkType;
    }
    
    return self;
}

- (void)addPayloadToData:(NSMutableData *)data{
    //base class do nothing
}

- (NSData*)data{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
    [data rw_appendInt32:'SNAP'];   // 0x534E4150
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    
    [self addPayloadToData:data];
    
    return data;
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

@end
