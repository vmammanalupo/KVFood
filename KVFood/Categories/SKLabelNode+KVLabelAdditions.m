//
//  SKLabelNode+KVLabelAdditions.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "SKLabelNode+KVLabelAdditions.h"

@implementation SKLabelNode (KVLabelAdditions)

+ (SKLabelNode *)pointsAcquiredLabel {
    SKLabelNode *pointsAcquiredLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    pointsAcquiredLabel.fontColor = [SKColor yellowColor];
    pointsAcquiredLabel.fontSize = 40;
    pointsAcquiredLabel.alpha = 0;
    pointsAcquiredLabel.zPosition = 4;
    pointsAcquiredLabel.hidden = YES;
    
    return pointsAcquiredLabel;
}

+ (void)addPointsAcquiredLabelToScene:(SKScene *)scene
                           atPosition:(CGPoint)position
                           withPoints:(NSString *)pointsEarned {
    SKLabelNode *label = [SKLabelNode pointsAcquiredLabel];
    label.text = pointsEarned;
    label.position = position;
    label.hidden = NO;
    
    [scene addChild:label];
    
    SKAction *flashAction = [SKAction sequence:@[
                                                 [SKAction fadeInWithDuration:0.2],
                                                 [SKAction waitForDuration:0.2],
                                                 [SKAction fadeOutWithDuration:0.2]
                                                 ]];
    
    [label runAction:flashAction completion:^{ label.hidden = YES; }];
}

@end
