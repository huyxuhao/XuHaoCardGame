//
//  Player.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/10/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize position, name, peerID;
@synthesize receivedResponse;

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"Dealloc %@",self);
#endif
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = %d", [super description], self.peerID, self.name, self.position];
}
    
@end
