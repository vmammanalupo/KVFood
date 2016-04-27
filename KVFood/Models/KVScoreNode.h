//
//  KVScoreNode.h
//  KVFood
//
//  Created by Kyle Yoon on 4/27/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface KVScoreNode : SKLabelNode

@property (nonatomic, assign) int currentScore;

+ (instancetype)zeroScoreNode;

- (void)updateScoreByPoints:(int)points;

@end
