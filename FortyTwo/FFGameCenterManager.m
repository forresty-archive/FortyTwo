//
//  FFGameCenterManager.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FFGameCenterManager.h"

// frameworks
// -- game center
#import <GameKit/GameKit.h>


@interface FFGameCenterManager ()

@property (nonatomic) BOOL gameCenterEnabled;

@end


@implementation FFGameCenterManager


+ (instancetype)sharedManager {
  static FFGameCenterManager *_instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });

  return _instance;
}


# pragma mark - private


- (id)init {
  self = [super init];

  if (self) {
    [self setupGameCenter];
  }

  return self;
}

- (void)setupGameCenter {
  __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

  localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
    if (viewController) {
      // don't present this view controller for now
      self.gameCenterEnabled = NO;
    } else if (localPlayer.isAuthenticated) {
      self.gameCenterEnabled = YES;
    } else {
      self.gameCenterEnabled = NO;
    }
  };
}


# pragma mark - leaderboard score reporting


- (void)reportScore:(int64_t)score forLeaderBoardIdentifier:(NSString *)identifier {
  NSParameterAssert(self.gameCenterEnabled);
  GKScore *scoreReporter = [[GKScore alloc] initWithCategory:identifier];
  scoreReporter.value = score;
  scoreReporter.context = 0;

  [scoreReporter reportScoreWithCompletionHandler:nil];
}


@end
