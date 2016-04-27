//
//  KVScoreNode.m
//  KVFood
//
//  Created by Kyle Yoon on 4/27/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVScoreNode.h"
#import "KVConstants.h"

@implementation KVScoreNode

+ (instancetype)zeroScoreNode {
    KVScoreNode *scoreNode = [[KVScoreNode alloc] initWithFontNamed:@"Hiragino Sans W6"];
    scoreNode.fontSize = 50.0;
    scoreNode.fontColor = [UIColor yellowColor];
    scoreNode.text = @"0";
    scoreNode.zPosition = KVZPositionTypeHUD;
    scoreNode.currentScore = 0;
    
    return scoreNode;
}

- (void)updateScoreByPoints:(int)points {
    self.currentScore = self.currentScore + points;
    self.text = [NSString stringWithFormat:@"%d", self.currentScore];
}

@end
