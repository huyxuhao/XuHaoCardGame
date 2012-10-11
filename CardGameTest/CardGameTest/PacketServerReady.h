//
//  PacketServerReady.h
//  CardGameTest
//
//  Created by Anlab JSC on 10/11/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "Packet.h"

@interface PacketServerReady : Packet

@property(nonatomic,strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)pls;

@end
