//
//  FTTMGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMGameViewController.h"

// views
#import "FTTMUniverseView.h"


@interface FTTMGameViewController ()

@property (nonatomic) FTTMUniverseView *universeView;

@end


@implementation FTTMGameViewController

- (id)init {
  self = [super init];

  if (self) {
    self.view = [[FTTMUniverseView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
  }
    
  return self;
}


@end
