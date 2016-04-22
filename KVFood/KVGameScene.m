//
//  KVGameScene.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVGameScene.h"
#import "KVLoseScene.h"
#import "KVPlayerNode.h"
#import "KVEnemyNode.h"
#import "KVConstants.h"
#include <stdlib.h>

@interface KVGameScene () <SKPhysicsContactDelegate>

@property(nonatomic) BOOL gameIsPaused;

@property(nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property(nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property(nonatomic) KVPlayerNode *player;

@end

@implementation KVGameScene

- (void)didMoveToView:(SKView *)view {
    self.gameIsPaused = NO;
    [self createPhysicsWorld];
    self.player = [[KVPlayerNode alloc] initAtPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    self.player.xScale = 0.3;
    self.player.yScale = 0.3;
    [self addChild:self.player];
}

- (void)createPhysicsWorld {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
}

#pragma mark - Random Generator Methods

- (CGPoint)randomSpawnPoint {
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    CGFloat radius = self.frame.size.width/2;
    
    float random = arc4random_uniform(UINT32_MAX);
    float divisor = UINT32_MAX;
    float MPI = M_PI;
    
    float theta = (random/divisor) * MPI * 2.0;
    CGFloat xPosition = center.x + radius * cosf(theta);
    CGFloat yPosition = center.y + radius * sinf(theta);
    
    return CGPointMake(xPosition, yPosition);
}

- (int)randomizedDurationFromTimeRangeOfMinimum:(int)minimum andMaximum:(int)maximum {
    int minDuration = minimum;
    int maxDuration = maximum;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    return actualDuration;
}

- (CGFloat)rotationForSpawnPoint:(CGPoint)point {
    CGPoint origin = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat distance = sqrt(point.x * point.x + point.y * point.y);
    CGFloat xVelocity = point.x - origin.x;
    CGFloat yVelocity = point.y - origin.y;
    CGFloat radians = fabs(xVelocity / distance);
    
    NSLog(@"%f %f", xVelocity, yVelocity);
    CGFloat rotation;
    // 1
    if (xVelocity > 0 && yVelocity > 0) {
        NSLog(@"FIRST");
        rotation = M_PI / 2 + radians;
    }
    // 2
    else if (xVelocity < 0 && yVelocity > 0) {
        NSLog(@"SECOND");
        rotation = - M_PI / 2 - radians;
    }
    // 3
    else if (xVelocity < 0 && yVelocity < 0) {
        NSLog(@"THIRD");
        rotation = radians - M_PI / 2;
    }
    // 4
    else {
        NSLog(@"FOURTH");
        rotation = M_PI / 2 - radians;
    }
    
    return rotation;
}

#pragma mark - Update methods

- (void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    if (!self.gameIsPaused) {
        [self updateWithTimesinceLastUpdate:timeSinceLast];
    }
}

- (void)updateWithTimesinceLastUpdate:(CFTimeInterval) timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    
    if (self.lastSpawnTimeInterval > 0.75 && !self.gameIsPaused) {
        self.lastSpawnTimeInterval = 0;
        [self addEnemy];
    }
}

- (void)addEnemy {
    CGPoint spawnPoint = [self randomSpawnPoint];
    KVEnemyNode *enemy = [KVEnemyNode createEnemyAtPosition:spawnPoint ofType:arc4random_uniform(3)];
    enemy.zRotation = [self rotationForSpawnPoint:spawnPoint]; // TODO: Refactor this method
    [self addChild:enemy];
    
    int randomDuration = [self randomizedDurationFromTimeRangeOfMinimum:2 andMaximum:4];
    SKAction *enemyAction =[SKAction moveTo:self.player.position duration:randomDuration];
    
    [enemy runAction:enemyAction completion:^{
        if (self) {
            [enemy removeFromParent];
        }
    }];
}

#pragma mark - Collision Detection

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & KVCollisionCategoryAlly) != 0 &&
        ((secondBody.categoryBitMask & KVCollisionCategoryEnemy) != 0)) {
        [self ally:(SKSpriteNode *)firstBody.node didCollideWithEnemy:(SKSpriteNode *)secondBody.node];
    }
    
    if ((firstBody.categoryBitMask & KVCollisionCategoryPlayer) != 0 &&
        ((secondBody.categoryBitMask & KVCollisionCategoryEnemy) != 0)) {
        [self enemy:(SKSpriteNode *)secondBody.node didCollideWithPlayer:(SKSpriteNode *)firstBody.node];
    }
}

//Actions for Ally hitting an Enemy
- (void)ally:(SKSpriteNode *)ally didCollideWithEnemy:(SKSpriteNode *)enemy {
    //This is where we would add update points/add point labels
    //Also can add removal logic for both allies and enemies
    [enemy removeFromParent];
}

//Actions for Enemy hitting Player
- (void)enemy:(SKSpriteNode *)enemy didCollideWithPlayer:(SKSpriteNode *)player {
    //Deduct health
    //Update Scores
    //Add removal logic
    [enemy removeFromParent];
    self.player.healthPoints = self.player.healthPoints - 1;
    
    if (self.player.healthPoints == 0)
    {
        SKAction * loseAction = [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            SKScene *gameOverScene = [[KVLoseScene alloc] initWithSize:self.size withEnemiesKilled:1 withScore:1];;
            [self.view presentScene:gameOverScene transition:reveal];
        }];
        
        [self runAction:loseAction];
    }
}

@end
