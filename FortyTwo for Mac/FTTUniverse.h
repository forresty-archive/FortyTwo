//
//  FTTUniverse.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FTTMUniverseView.h"


typedef NS_ENUM(NSUInteger, FTTMUserObjectVerticalHeading) {
  FTTMUserObjectVerticalHeadingNone,
  FTTMUserObjectVerticalHeadingUp,
  FTTMUserObjectVerticalHeadingDown,
};

typedef NS_ENUM(NSUInteger, FTTMUserObjectHorizontalHeading) {
  FTTMUserObjectHorizontalHeadingNone,
  FTTMUserObjectHorizontalHeadingLeft,
  FTTMUserObjectHorizontalHeadingRight,
};


@interface FTTUniverse : NSObject <FTTMUniverseViewDataSource>

- (void)tick;

@property (nonatomic, readonly) NSMutableArray *enemies;

// user control
@property (nonatomic) FTTMUserObjectVerticalHeading userObjectVerticalHeading;
@property (nonatomic) FTTMUserObjectHorizontalHeading userObjectHorizontalHeading;

@end
