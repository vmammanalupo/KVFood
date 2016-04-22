//
//  KVPlayerNode.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVPlayerNode.h"
#import "KVConstants.h"

@implementation KVPlayerNode

- (instancetype)initAtPosition:(CGPoint)position {
    if (self = [super init]) {
        self.position = position;
        self.zPosition = 1;
        
        SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        [self addChild:player];
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
        self.physicsBody.dynamic = NO;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsBody.categoryBitMask = KVCollisionCategoryPlayer;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = KVCollisionCategoryEnemy;
        
        _healthPoints = 5;
        
        return self;
    }
    return nil;
}

@end
