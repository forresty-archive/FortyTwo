//
//  FTTMAppDelegate.m
//  FortyTwo for Mac
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMAppDelegate.h"

#import "FTTMGameViewController.h"


@implementation FTTMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self restartGame];
}

- (void)restartGame {
  if (self.gameViewController) {
    if (self.gameViewController.gamePlaying) {
      [self.gameViewController stopGame];
    }
    [self.gameViewController.view removeFromSuperview];
  }

  self.gameViewController = [[FTTMGameViewController alloc] init];

  self.gameViewController.view.frame = ((NSView *)self.window.contentView).bounds;

  [self.window.contentView addSubview:self.gameViewController.view];

  [self.window makeFirstResponder:self.gameViewController];
}


@end
