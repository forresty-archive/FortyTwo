//
//  FFAudioManager.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FFAudioManager.h"

#import <AVFoundation/AVFoundation.h>


@implementation FFAudioManager

+ (instancetype)defaultManager {
  static FFAudioManager *_instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });

  return _instance;
}

- (void)vibrate {
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
