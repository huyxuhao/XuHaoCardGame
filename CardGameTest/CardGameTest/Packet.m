//
//  Packet.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/10/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "Packet.h"
#import "NSData+SnapAdditions.h"

@implementation Packet
@synthesize packetType;

+ (id)packetWithType:(PacketType)pkType{
    return  [[[self class] alloc] initWithType:pkType];
}

- (id)initWithType:(PacketType)pkType{
    if(self = [super init]){
        self.packetType = pkType;
    }
    
    return self;
}

- (NSData*)data{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
    [data rw_appendInt32:'SNAP'];   // 0x534E4150
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    
    return data;
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

@end
