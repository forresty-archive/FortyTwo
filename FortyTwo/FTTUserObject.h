//
//  FTTUserObject.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTObject.h"


@interface FTTUserObject : FTTObject

+ (void)registerDefaultSpawnPosition:(CGPoint)position;

- (void)resetPosition;

@end
