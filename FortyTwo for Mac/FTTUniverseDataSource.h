//
//  FTTUniverseDataSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTUniverseViewDataSource.h"
#import "FTTMKeyboardInputSourceDelegate.h"


@class FTTUniverse;


@interface FTTUniverseDataSource : NSObject <FTTUniverseViewDataSource, FTTMKeyboardInputSourceDelegate>

- (instancetype)initWithUniverse:(FTTUniverse *)universe;

@end
