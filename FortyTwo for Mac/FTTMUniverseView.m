//
//  FTTMUniverseView.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMUniverseView.h"

@implementation FTTMUniverseView

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];

  if (self) {
    NSLog(@"frame %@", NSStringFromRect(frame));
    // Initialization code here.
  }
  
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor blackColor] setFill];
  [[NSBezierPath bezierPathWithRect:dirtyRect] fill];
}

@end
