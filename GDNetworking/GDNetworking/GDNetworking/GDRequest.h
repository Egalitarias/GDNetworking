//
//  GDRequest.h
//  GDNetworking
//
//  Created by Gary Davies on 25/04/2014.
//  Copyright (c) 2014 Gary Davies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDRequestDelegate <NSObject>

@optional
-(void)update;
-(void)successUpdate:(NSDictionary *)request response:(NSDictionary *)response;
-(void)failUpdate:(NSDictionary *)request response:(NSDictionary *)response error:(NSError *)error;

@end

@interface GDRequest : NSObject

-(void)submitRequestUsingDictionary:(NSDictionary *)requestParameters delegate:(id<GDRequestDelegate>)theDelegate;
-(NSDictionary *)submitSynchronousRequestUsingDictionary:(NSDictionary *)requestParameters;

@end
