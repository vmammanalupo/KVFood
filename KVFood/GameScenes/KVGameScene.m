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
#import "KVScoreNode.h"
#include <stdlib.h>

@interface KVGameScene () <SKPhysicsContactDelegate>

@property (nonatomic) BOOL gameIsPaused;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (nonatomic) KVPlayerNode *player;
@property (nonatomic) KVScoreNode *scoreNode;

@end

@implementation KVGameScene

- (void)didMoveToView:(SKView *)view {
    self.gameIsPaused = NO;
    [self createPhysicsWorld];
    
    CGPoint midPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    // TODO: Subclass this?
    // Adding a background node
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    backgroundNode.size = self.frame.size;
    backgroundNode.position = midPoint;
    backgroundNode.alpha = 0.75;
    backgroundNode.zPosition = KVZPositionTypeBackground;
    [self addChild:backgroundNode];
    
    // Adding the player (pizza)
    self.player = [[KVPlayerNode alloc] initAtPosition:midPoint];
    self.player.xScale = 0.8;
    self.player.yScale = 0.8;
    [self addChild:self.player];

    // TODO: Subclass this?
    // Adding the score
    self.scoreNode = [KVScoreNode zeroScoreNode];
    self.scoreNode.position = CGPointMake(CGRectGetWidth(self.frame) / 9, CGRectGetHeight(self.frame) / 6); // TODO: Make this better
    [self addChild:self.scoreNode];
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

#pragma mark - Update methods

- (void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 30.0;
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
    [self addChild:enemy];
    // Rotate towards player
    CGFloat angle = atan2(spawnPoint.y - self.player.position.y, spawnPoint.x - self.player.position.x) + M_PI;
    SKAction *rotateAction = [SKAction rotateToAngle:angle duration:0.0];
    // Move towards player
    int randomDuration = [self randomizedDurationFromTimeRangeOfMinimum:2 andMaximum:4];
    SKAction *moveAction =[SKAction moveTo:self.player.position duration:randomDuration];
    SKAction *spawnActionSequence = [SKAction sequence:@[rotateAction, moveAction]];
    [enemy runAction:spawnActionSequence
          completion:^{
              if (self) {
                  [enemy removeFromParent];
              }
          }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        
        if ([node.name isEqualToString:@"Pause"]) {
            if (!self.gameIsPaused) {
                self.paused = YES;
                self.gameIsPaused = YES;
            }
            else {
                self.paused = NO;
                self.gameIsPaused = NO;
            }
            
            return;
        }
        else if ([node.name isEqualToString:@"Enemy"]) {
            KVEnemyNode *enemy = (KVEnemyNode *)node;
            [enemy performEnemyDamagedByPlayerAction];
            if (!enemy.healthPoints) {
                [self.scoreNode updateScoreByPoints:enemy.pointValue];
            }
        }
    }
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
    KVEnemyNode *enemyNode = (KVEnemyNode *)enemy;
    //Deduct health
    //Add removal logic
    [enemyNode removeFromParent];
//    self.player.healthPoints = self.player.healthPoints - 1;
    
    if (self.player.healthPoints == 0) {
        SKAction * loseAction = [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            SKScene *gameOverScene = [[KVLoseScene alloc] initWithSize:self.size withEnemiesKilled:1 withScore:1];;
            [self.view presentScene:gameOverScene transition:reveal];
        }];
        
        [self runAction:loseAction];
    }
}

@end
