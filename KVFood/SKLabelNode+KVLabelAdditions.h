//
//  SKLabelNode+KVLabelAdditions.h
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKLabelNode (KVLabelAdditions)

/**
 *  Convenience Init - Creates an SKLabelNode in the primary font and color
 *
 *  @return SKLabelNode
 */
+ (SKLabelNode *)pointsAcquiredLabel;

/**
 *  Convenience Init - Creates an SKLabelNode at the specified position displaying the points earned
 *
 *  @param scene            SKScene to contain the label
 *  @param position         CGPoint of the location of the label
 *  @param pointsEarned     NSString of the text for the label to display
 *
 *  @return SKLabelNode
 */
+ (void)addPointsAcquiredLabelToScene:(SKScene *)scene
                           atPosition:(CGPoint)position
                           withPoints:(NSString *)pointsEarned;

@end
