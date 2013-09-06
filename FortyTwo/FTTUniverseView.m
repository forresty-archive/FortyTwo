//
//  FTTUniverseView.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUniverseView.h"


@interface FTTUniverseView ()

@end


@implementation FTTUniverseView


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self) {
    self.backgroundColor = [UIColor blackColor];
  }

  return self;
}

- (BOOL)bombAvailable {
  return self.bombCooldownTime >= FTTBombCooldownTime;
}

- (void)deployBomb {
  self.bombDeployed = YES;
}


@end
