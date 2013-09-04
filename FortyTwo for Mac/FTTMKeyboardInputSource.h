//
//  FTTKeyboardInputSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTMKeyboardInputSourceDelegate.h"


@class FTTSpeedVector;


@interface FTTMKeyboardInputSource : NSResponder

@property (nonatomic, weak) id<FTTMKeyboardInputSourceDelegate> delegate;

@property (nonatomic, readonly) FTTSpeedVector *userSpeedVector;

@end
