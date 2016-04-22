//
//  KVEnemyNode.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVEnemyNode.h"
#import "KVConstants.h"

@implementation KVEnemyNode

- (BOOL)collisionWithPlayer:(SKNode *)player {
    //Run Collision Actions - can toggle custom ones by TYPE
    return NO;
}

+ (KVEnemyNode *)createEnemyAtPosition:(CGPoint)position ofType:(EnemyType)type {
    KVEnemyNode *node = [KVEnemyNode node];
    [node setPosition:position];
    [node setName:@"Enemy"];
    [node setEnemyType:type];
    
    SKSpriteNode *sprite;
    if (type == ENEMY_HAND) {
        //USE HAND IMAGE
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.color = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0];
        sprite.colorBlendFactor = 1.0f;
    }
    else if (type == ENEMY_FORK) {
        //USE FORK IMAGE
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.color = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0];
        sprite.colorBlendFactor = 1.0f;
    }
    else {
        //USE KNIFE IMAGE
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.color = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
        sprite.colorBlendFactor = 1.0f;
    }
    [node addChild:sprite];
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    node.physicsBody.dynamic = YES;
    node.physicsBody.categoryBitMask = KVCollisionCategoryEnemy;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

@end
