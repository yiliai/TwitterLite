//
//  JsonDiskCache.m
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JsonDiskCache.h"


@implementation JsonDiskCache

+ (NSString *)pathForCacheFile {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/response.json"];
}

// Synchronized write
+ (BOOL)cache:(id)JSON {
    NSError *error;
    
    if (!JSON || ![NSJSONSerialization isValidJSONObject:JSON]) {
        return NO;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSON
                    options:0
                    error:&error];
    if (error != nil) {
        return NO;
    }
    NSString *jsonPath = [JsonDiskCache pathForCacheFile];
    BOOL success = NO;
    @synchronized(self) {
        success = [data writeToFile:jsonPath atomically:YES];
        if (success) {
            [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey: NSFileProtectionNone}
                                             ofItemAtPath:jsonPath
                                                    error:&error];
            return YES;
        }
    }
    return NO;
}

// Synchronized read
+ (id)cached {
    NSString *filePath = [JsonDiskCache pathForCacheFile];
    NSData *responseData = nil;
    @synchronized(self) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            responseData = [NSData dataWithContentsOfFile:filePath];
        }
    }
    if (!responseData) {
        return nil;
    }
    NSError *error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    return json;
}

// Synchronized clear
+ (void)clearCache {
    NSError *error = nil;
    BOOL result = YES;
    NSString *filePath = [JsonDiskCache pathForCacheFile];
    @synchronized(self) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            result = [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                                error:&error];
        }
    }
    if (error != nil) {
        NSLog(@"An error occurred clearing the cache: %@", [error localizedDescription]);
    }
}

@end