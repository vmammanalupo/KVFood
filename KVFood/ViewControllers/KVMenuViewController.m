//
//  KVMenuViewController.m
//  KVFood
//
//  Created by Mammana-Lupo, Vince on 4/21/16.
//  Copyright © 2016 Kyle&Vince. All rights reserved.
//

#import "KVMenuViewController.h"
#import "KVGameCenterClient.h"
#import <GameKit/GameKit.h>

@import AVFoundation;

@interface KVMenuViewController () <GKGameCenterControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *backgroundMusicPlayer;

@end

@implementation KVMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[KVGameCenterClient sharedInstance] getLeaderBoardIdentifier];
    self.navigationController.navigationBarHidden = YES;
    [self addBackgroundMusicToGameWithFileName:@"POL_Cyber_Factory" ofFileType:@"wav"];
}

- (void)addBackgroundMusicToGameWithFileName:(NSString *)fileName ofFileType:(NSString *)type {
    NSError *error;
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSURL *backgroundMusicURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard {
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        //Show LeaderBoard
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = [KVGameCenterClient sharedInstance].leaderBoardIdentifier;
    }
    else {
        //Show Achievements
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedLeaderBoard:(id)sender {
    [self showLeaderboardAndAchievements:YES];
}

@end
