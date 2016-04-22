//
//  KVEnemyNode.h
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, EnemyType) {
    ENEMY_HAND,
    ENEMY_FORK,
    ENEMY_KNIFE,
};

@interface KVEnemyNode : SKSpriteNode

//The type of enemy generated
@property (nonatomic, assign) EnemyType enemyType;

/**
 *  Convenience Init - Creates an enemy at a specified position of a specified type
 *
 *  @param position         CGPoint of the location of the enemy
 *  @param type             EnemyType is the type of enemy generated
 *
 *  @return KVEnemyNode     Returns a KVEnemyNode at the position of the specified type
 */
+ (KVEnemyNode *)createEnemyAtPosition:(CGPoint)position ofType:(EnemyType)type;

@end
