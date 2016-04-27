//
//  KVConstants.h
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kArrowNodes 1

typedef NS_ENUM(NSInteger, KVZPositionType) {
    KVZPositionTypeBackground,
    KVZPositionGameNode,
    KVZPositionTypeHUD,
};

@interface KVConstants : NSObject

typedef NS_OPTIONS(uint32_t, KVCollisionCategory) {
    KVCollisionCategoryPlayer     = 0x1 << 0,
    KVCollisionCategoryEnemy      = 0x1 << 1,
    KVCollisionCategoryAlly       = 0x1 << 2,
};

//We can probably make all node names a constant here so we can reference them everywhere

@end
