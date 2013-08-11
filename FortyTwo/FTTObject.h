//
//  FTTObject.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSUInteger DeviceWidth() {
  return [UIScreen mainScreen].bounds.size.width;
}


static NSUInteger DeviceHeight() {
  return [UIScreen mainScreen].bounds.size.height;
}

@interface FTTObject : NSObject

@property (nonatomic) CGPoint position;

- (void)resetPosition;

@end
