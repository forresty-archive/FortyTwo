//
//  FTTObject.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTTObject : NSObject

@property (nonatomic) CGFloat width;
@property (nonatomic) CGPoint position;

+ (void)registerDefaultObjectWidth:(CGFloat)width;

- (void)resetPosition;

@end
