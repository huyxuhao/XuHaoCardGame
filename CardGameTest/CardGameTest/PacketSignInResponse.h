//
//  PacketSignInResponse.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/11/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "Packet.h"

@interface PacketSignInResponse : Packet

@property (nonatomic,copy) NSString *playerName;

+(id)packetWithPlayerName:(NSString*)pName;

@end
