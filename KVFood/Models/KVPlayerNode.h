//
//  KVPlayerNode.h
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface KVPlayerNode : SKSpriteNode

//The current healthPoints of a player - max is 5
@property (nonatomic, assign) int healthPoints;

/**
 *  Convenience Init - Creates a player at a specified position
 *
 *  @param position         CGPoint of the location of the player
 *
 *  @return KVPlayerNode    Returns a KVPlayerNode at the specified position
 */
- (instancetype)initAtPosition:(CGPoint)position;

@end
