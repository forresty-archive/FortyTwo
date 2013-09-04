//
//  FTTInputSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTTSpeedVector;


@interface FTTInputSource : NSResponder

@property (nonatomic, readonly) FTTSpeedVector *userSpeedVector;

@end
