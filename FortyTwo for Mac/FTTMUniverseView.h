//
//  FTTMUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FTTMUniverseViewDataSource.h"


@class FTTUserObject;


@interface FTTMUniverseView : NSView

@property (nonatomic) id<FTTMUniverseViewDataSource> dataSource;

@end
