//
//  PacketSignInResponse.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/11/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "PacketSignInResponse.h"

@implementation PacketSignInResponse
@synthesize playerName;

+ (id)packetWithPlayerName:(NSString *)pName {
    return [[[self class] alloc] initWithPlayerName:pName];
}

- (id)initWithPlayerName:(NSString *)pName
{
	if ((self = [super initWithType:PacketTypeSiginInResponse]))
	{
		self.playerName = pName;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	size_t count;
	NSString *playerName = [data rw_stringAtOffset:PACKET_HEADER_SIZE bytesRead:&count];
	return [[self class] packetWithPlayerName:playerName];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.playerName];
}


@end
