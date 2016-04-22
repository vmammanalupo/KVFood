//
//  KVLoseScene.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVLoseScene.h"
#import "KVGameScene.h"

@interface KVLoseScene ()

@property (nonatomic) NSString *resultsMessage;

//Label Properties
@property (nonatomic) SKLabelNode *resultsLabel;
@property (nonatomic) SKLabelNode *killCount;
@property (nonatomic) SKLabelNode *finalScoreLabel;

@end

@implementation KVLoseScene

- (id)initWithSize:(CGSize)size
 withEnemiesKilled:(int)killCount
         withScore:(int)finalScore {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor greenColor];
        self.resultsMessage = NSLocalizedString(@"You Will Die of Hunger", @"You Will Die of Hunger");
        
        self.resultsLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.resultsLabel.text = self.resultsMessage;
        self.resultsLabel.fontSize = 40;
        self.resultsLabel.fontColor = [SKColor blackColor];
        self.resultsLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:self.resultsLabel];
        
        SKAction *restart = [SKAction sequence:@[
                                                 [SKAction waitForDuration:5.0],
                                                 [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            // Create and configure the scene.
            KVGameScene *scene = [KVGameScene nodeWithFileNamed:@"KVGameScene"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [self.view presentScene:scene transition:reveal];}]
                                                 ]];
        
        [self runAction:restart];
    }
    return self;
}

@end
