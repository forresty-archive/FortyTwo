//
//  FTTObject.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTObject.h"


@implementation FTTObject

static CGFloat FTTDefaultObjectWidth;

- (id)init {
  self = [super init];

  if (self) {
    self.width = FTTDefaultObjectWidth;
    [self resetPosition];
  }

  return self;
}

+ (void)registerDefaultObjectWidth:(CGFloat)width {
  FTTDefaultObjectWidth = width;
}


- (void)resetPosition {
  @throw @"should override";
}

@end
