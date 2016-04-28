//
//  KVGameCenterClient.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/27/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVGameCenterClient.h"

@implementation KVGameCenterClient

static KVGameCenterClient *sharedInstance;

+ (KVGameCenterClient *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KVGameCenterClient alloc] init];
    });
    
    return sharedInstance;
}

- (void)authenticateLocalPlayer {
    self.localPlayer = [GKLocalPlayer localPlayer];
    typeof(self) __weak weakSelf = self;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:viewController animated:YES completion:nil];
        }
        else if (self.localPlayer.isAuthenticated) {
            weakSelf.gameCenterEnabled = YES;
        }
        else {
            weakSelf.gameCenterEnabled = NO;
        }
    };
}

- (void)getLeaderBoardIdentifier {
    typeof(self) __weak weakSelf = self;
    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            weakSelf.leaderBoardIdentifier = leaderboardIdentifier;
        }
    }];
}

- (void)reportScore {
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderBoardIdentifier];
    score.value = self.highScore.value;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)getLocalPlayerHighScore {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    
    leaderboardRequest.identifier = self.leaderBoardIdentifier;
    
    if (leaderboardRequest != nil) {
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error){
            if (error != nil) {
                //Handle error
            }
            else {
                //                [delegate onLocalPlayerScoreReceived:leaderboardRequest.localPlayerScore];
            }
        }];
    }
}

@end
