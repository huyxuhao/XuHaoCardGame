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

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.playerName];
}


@end
