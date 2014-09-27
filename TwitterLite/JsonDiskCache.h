//
//  JsonDiskCache.h
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDiskCache : NSObject

+ (BOOL)cache:(id)JSON;
+ (id)cached;
+ (void)clearCache;

@end