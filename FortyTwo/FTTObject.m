//
//  FTTObject.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTObject.h"


@implementation FTTObject


- (id)init {
  self = [super init];

  if (self) {
    [self resetPosition];
  }

  return self;
}


- (void)resetPosition {
  @throw @"should override";
}

@end
