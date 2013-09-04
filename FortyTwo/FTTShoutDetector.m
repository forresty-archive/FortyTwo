//
//  FTTShoutDetector.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTShoutDetector.h"

// frameworks
// -- shout
#import <AVFoundation/AVFoundation.h>


@interface FTTShoutDetector ()

// audio
@property (nonatomic) AVAudioRecorder* recorder;
@property (nonatomic) NSTimer* levelTimer;
@property (nonatomic) CGFloat lowPassResults;

// shout
@property (nonatomic) BOOL shouting;

@end


@implementation FTTShoutDetector


- (id)init {
  self = [super init];

  if (self) {
    [self setupShoutDetection];
  }

  return self;
}


# pragma mark - shout detection


- (void)setupShoutDetection {
  NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];

  NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                            [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                            [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                            [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                            nil];

  NSError *error;

  self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];

  if (self.recorder) {
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                       target:self
                                                     selector:@selector(levelTimerCallback:)
                                                     userInfo:nil
                                                      repeats:YES];
  }
}

// http://stackoverflow.com/questions/10622721/audio-level-detect
- (void)levelTimerCallback:(NSTimer *)timer {
  [self.recorder updateMeters];

  const double ALPHA = 0.05;

  // I have no idea what this means...
  double peakPowerForChannel = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));

  // smooth
  self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;

  //  NSLog(@"%f",(self.lowPassResults * 100.0f));

  if (self.shouting == NO && self.lowPassResults >= 0.5) {
    self.shouting = YES;
    [self.delegate shoutDetectorDidDetectShout];
  } else if (self.shouting == YES && self.lowPassResults < 0.5) {
    self.shouting = NO;
    [self.delegate shoutDetectorShoutDidEnd];
  }
}


@end
