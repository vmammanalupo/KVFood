//
//  KVEnemyNode.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVEnemyNode.h"
#import "KVConstants.h"
#import "SKLabelNode+KVLabelAdditions.h"

@implementation KVEnemyNode

- (BOOL)collisionWithPlayer:(SKNode *)player {
    //Run Collision Actions - can toggle custom ones by TYPE
    return NO;
}

+ (KVEnemyNode *)createEnemyAtPosition:(CGPoint)position ofType:(EnemyType)type {
    KVEnemyNode *node = [KVEnemyNode spriteNodeWithImageNamed:@"Spaceship"];
    if (type == ENEMY_HAND) {
        node.healthPoints = 1;
        node.pointValue = 5;
        //USE HAND IMAGE
        node.color = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0];
        node.colorBlendFactor = 1.0f;
    }
    else if (type == ENEMY_FORK) {
        //USE FORK IMAGE
        node.healthPoints = 2;
        node.pointValue = 10;
        node.color = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0];
        node.colorBlendFactor = 1.0f;
    }
    else {
        //USE KNIFE IMAGE
        node.healthPoints = 3;
        node.pointValue = 15;
        node.color = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
        node.colorBlendFactor = 1.0f;
    }
    
    [node setPosition:position];
    [node setName:@"Enemy"];
    node.xScale = 0.3;
    node.yScale = 0.3;
    node.spawnPoint = position;
    
    [node setEnemyType:type];
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    node.physicsBody.dynamic = YES;
    node.physicsBody.categoryBitMask = KVCollisionCategoryEnemy;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (void)performEnemyDamagedByPlayerAction {
    self.healthPoints --;
    //Play damage sound effect
    //        [self runAction:[SKAction playSoundFileNamed:kHeroShipDamagedSound waitForCompletion:NO]];
    SKAction *colorize = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.5];
    SKAction *reverse = [colorize reversedAction];
    SKAction *colorizeAndReverse = [SKAction sequence:@[colorize, reverse]];
    SKAction *repeatColorizeAndReverse = [SKAction repeatAction:colorizeAndReverse count:2];
    if (self.healthPoints > 0) {
        //Play damage sound effect
        [self runAction:colorizeAndReverse];
        SKAction *damagedKnockBack = [SKAction moveBy:[self vectorForDamagedKnockBackWithMagnitude:5] duration:0.2];
        [self runAction:damagedKnockBack];
    }
    //Dead
    else {
        //Play die sound effect
        //Stop enemy in its tracks
        [self removeAllActions];
        [SKLabelNode addPointsAcquiredLabelToScene:self.scene
                                        atPosition:self.position
                                        withPoints:[NSString stringWithFormat:@"%d", self.pointValue]];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
        typeof(self) __weak weakSelf = self;
        [self runAction:[SKAction group:@[repeatColorizeAndReverse, fadeOut]] completion:^{
            [weakSelf removeFromParent];
        }];
    }
}

- (CGVector)vectorForDamagedKnockBackWithMagnitude:(CGFloat)magnitude {
    return CGVectorMake(magnitude * (self.spawnPoint.x - self.position.x),
                        magnitude * (self.spawnPoint.y - self.position.y));
}

@end
