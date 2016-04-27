//
//  KVGameCenterClient.h
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/27/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface KVGameCenterClient : NSObject

//The Authenticated Local Player
@property (nonatomic, strong) GKLocalPlayer *localPlayer;

//True if the Local Player is authenticated
@property (nonatomic, assign) BOOL gameCenterEnabled;

//NSString identifier associated with the High Score LeaderBoard
@property (nonatomic, strong) NSString *leaderBoardIdentifier;

//The Local Player's high score
@property (nonatomic, strong) GKScore *highScore;

//The Local Player's most recent score
@property (nonatomic, strong) GKScore *currentScore;

//@returns a Singleton instance of the KVGameCenterClient
+ (KVGameCenterClient *)sharedInstance;

//Performs a Game Center API call to authenticate the local player
- (void)authenticateLocalPlayer;

//Get the default leaderboard identifier.
- (void)getLeaderBoardIdentifier;

//Report a new high score obtained by the player
- (void)reportScore;

@end
