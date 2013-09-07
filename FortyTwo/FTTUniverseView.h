//
//  FTTUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTTUniverseViewDataSource.h"

static const CGFloat FTTBombCooldownTime = 42.0;


@interface FTTUniverseView : UIView

@property (nonatomic) id<FTTUniverseViewDataSource> dataSource;

@end
