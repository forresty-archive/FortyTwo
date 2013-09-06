//
//  FTTAlertViewManager.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTAlertViewManager.h"


@interface FTTAlertViewManager ()

@property (nonatomic, weak) id<UIAlertViewDelegate> alertViewDelegate;

@end


@implementation FTTAlertViewManager


+ (instancetype)defaultManager {
  static FTTAlertViewManager *_instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[FTTAlertViewManager alloc] init];
  });

  return _instance;
}


- (void)showGameOverAlertWithTimeLasted:(NSTimeInterval)timeLasted {
  NSString *messageFormat = NSLocalizedString(@"You lasted %.1f seconds.", nil);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are dead.", nil)
                                                  message:[NSString stringWithFormat:messageFormat, timeLasted]
                                                 delegate:self.alertViewDelegate
                                        cancelButtonTitle:NSLocalizedString(@"Retry", nil)
                                        otherButtonTitles: nil];

  [alert show];
}


- (void)showGamePausedAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Paused", nil)
                                                  message:nil
                                                 delegate:self.alertViewDelegate
                                        cancelButtonTitle:NSLocalizedString(@"Resume", nil)
                                        otherButtonTitles:nil];

  [alert show];
}

- (void)setAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate {
  self.alertViewDelegate = alertViewDelegate;
}

@end
