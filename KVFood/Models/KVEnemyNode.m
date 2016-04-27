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
    KVEnemyNode *node;
    // TODO: Edit assets to all point right. That way we can standardize rotation.
    if (type == ENEMY_HAND) {
#if kArrowNodes
        node = [KVEnemyNode spriteNodeWithImageNamed:@"arrow"];
        node.color = [UIColor redColor];
        node.xScale = 0.3;
        node.yScale = 0.3;
        node.colorBlendFactor = 1.0;
#else
        node = [KVEnemyNode spriteNodeWithImageNamed:@"arm"];
#endif
        node.healthPoints = 1;
        node.pointValue = 5;
    }
    else if (type == ENEMY_FORK) {
#if kArrowNodes
        node = [KVEnemyNode spriteNodeWithImageNamed:@"arrow"];
        node.color = [UIColor blueColor];
        node.xScale = 0.3;
        node.yScale = 0.3;
        node.colorBlendFactor = 1.0;
#else
        node = [KVEnemyNode spriteNodeWithImageNamed:@"fork"];
#endif
        node.healthPoints = 2;
        node.pointValue = 10;
    }
    else {
        //USE KNIFE IMAGE
#if kArrowNodes
        node = [KVEnemyNode spriteNodeWithImageNamed:@"arrow"];
        node.color = [UIColor yellowColor];
        node.xScale = 0.3;
        node.yScale = 0.3;
        node.colorBlendFactor = 1.0;
#else
        node = [KVEnemyNode spriteNodeWithImageNamed:@"knife"];
#endif
        node.healthPoints = 3;
        node.pointValue = 15;
    }
    
    [node setPosition:position];
    [node setName:@"Enemy"];
    node.zPosition = 1;
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
        [self removeAllActions];
        SKAction *damagedKnockBack = [SKAction moveBy:[self vectorForDamagedKnockBackWithMagnitude:0.5] duration:0.2];
        
        SKAction *colorizedDamageKnockBack = [SKAction group:@[colorizeAndReverse, damagedKnockBack]];
        
        CGPoint sceneCenter =  CGPointMake(self.scene.frame.size.width/2, self.scene.frame.size.height/2);
        
        SKAction *moveToCenter = [SKAction moveTo:sceneCenter duration:1.25];
        
        [self runAction:[SKAction sequence:@[colorizedDamageKnockBack, moveToCenter]]];
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
