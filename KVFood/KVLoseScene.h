//
//  KVLoseScene.h
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface KVLoseScene : SKScene

- (id)initWithSize:(CGSize)size
 withEnemiesKilled:(int)killCount
         withScore:(int)finalScore;

@end
