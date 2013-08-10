//
//  FTTGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/10/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTGameViewController.h"

#import <CoreMotion/CoreMotion.h>


@interface FTTGameViewController ()

@end


@implementation FTTGameViewController


+ (instancetype)sharedInstance {
  static FTTGameViewController *_instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });

  return _instance;
}


- (instancetype)init {
  self = [super init];

  if (self) {
    self.wantsFullScreenLayout = YES;
  }

  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor yellowColor];
}


@end
