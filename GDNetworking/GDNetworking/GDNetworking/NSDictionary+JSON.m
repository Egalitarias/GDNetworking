//
//  NSDictionary+JSON.m
//  Fitness
//
//  Created by Gary Davies on 12/01/2014.
//  Copyright (c) 2014 Gary Davies. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

-(NSString*) json:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
