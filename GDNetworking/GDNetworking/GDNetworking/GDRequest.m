//
//  GDRequest.m
//  GDNetworking
//
//  Created by Gary Davies on 25/04/2014.
//  Copyright (c) 2014 Gary Davies. All rights reserved.
//

#import "GDRequest.h"
#import "NSDictionary+JSON.h"

@implementation GDRequest {
    NSDictionary *request;
    id<GDRequestDelegate> delegate;
    NSMutableData *responseData;
    NSDictionary *headers;
    long statusCode;
}

-(void)submitRequestUsingDictionary:(NSDictionary *)requestParameters delegate:(id<GDRequestDelegate>)theDelegate {
    delegate = theDelegate;
    request = requestParameters;
    delegate = theDelegate;
    NSString *apiPath = [requestParameters objectForKey: @"url"];
    NSString *method = [requestParameters objectForKey: @"method"];
    
    if([self requestNeedsBody:method] == false) {
        NSDictionary *getParameters = [requestParameters objectForKey: @"parameters"];
        NSString *query = @"";
        NSString *value = nil;
        for(NSString *key in getParameters) {
            value = [getParameters objectForKey:key];
            if([query length] == 0) {
                query = [NSString stringWithFormat:@"%@=%@", key, value];
            }
            else {
                query = [NSString stringWithFormat:@"%@&%@=%@", query, key, value];
            }
        }
        NSString *getApiPath = [NSString stringWithFormat:@"%@?%@", apiPath, query];
        apiPath = getApiPath;
    }
    
    NSDictionary *requestHeaders = [requestParameters objectForKey:@"headers"];
    NSDictionary *parameters = [requestParameters objectForKey:@"parameters"];
    NSString *jsonRequest = [parameters json:NO];
    NSURL *url = [NSURL URLWithString:apiPath];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * value = nil;
    
    for(NSString *key in requestHeaders) {
        value = [requestHeaders objectForKey:key];
        [urlRequest setValue:value forHTTPHeaderField:key];
    };
    
    [urlRequest setHTTPMethod:method];
    
    if([self requestNeedsBody:method]) {
        NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody: requestData];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];

    if (connection) {
        responseData = [NSMutableData data];
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    headers = [httpResponse allHeaderFields];
    statusCode = [httpResponse statusCode];
    NSString * value = nil;
    
    for(NSString *key in headers) {
        value = [headers objectForKey:key];
    };
    
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    NSDictionary *body = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if(body == nil) {
        body = @{};
    }
    
    NSDictionary *response = @{ @"statusCode" : [NSNumber numberWithInteger:statusCode], @"headers" : headers, @"body" : body};
    [delegate successUpdate:request response:response];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(headers == nil) {
        headers = @{};
    }
    
    NSDictionary *response = @{ @"statusCode" : [NSNumber numberWithInteger:9000], @"headers" : headers, @"body" : @{}};
    [delegate failUpdate:request response:response error:error];
}

-(NSDictionary *)submitSynchronousRequestUsingDictionary:(NSDictionary *)requestParameters {
    NSURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSMutableURLRequest *urlRequest = [self buildRequest:requestParameters];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    NSDictionary *body = @{};
    
    if((data != nil) && ([data length] > 0)) {
        NSDictionary *tmp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if(tmp != nil) {
            body = tmp;
        }
        
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)urlResponse;
    headers = [httpResponse allHeaderFields];
    
    if(headers == nil) {
        headers = @{};
    }
    
    statusCode = [httpResponse statusCode];
    NSDictionary *response = @{ @"statusCode" : [NSNumber numberWithInteger:statusCode], @"headers" : headers, @"body" : body};
    
    return response;
}


#pragma mark - Private methods
-(NSMutableURLRequest *)buildRequest:(NSDictionary *)requestParameters {
    request = requestParameters;
    NSString *apiPath = [requestParameters objectForKey: @"url"];
    NSString *method = [requestParameters objectForKey: @"method"];
    NSDictionary *requestHeaders = [requestParameters objectForKey:@"headers"];
    NSDictionary *parameters = [requestParameters objectForKey:@"parameters"];
    
    if([self requestNeedsBody:method] == false) {
        NSString * getParameters = @"";
        NSString *value = nil;
        
        for(NSString *key in parameters) {
            value = [parameters objectForKey:key];
            
            if([getParameters length] == 0) {
                getParameters = [NSString stringWithFormat:@"%@=%@", key, value];
            }
            else {
                getParameters = [NSString stringWithFormat:@"%@&%@=%@", getParameters, key, value];
            }
            
        }
        
        if([getParameters length] > 0) {
            NSString *getApiPath = [NSString stringWithFormat:@"%@?%@", apiPath, getParameters];
            apiPath = getApiPath;
        }
        
    }
    
    NSString *jsonRequest = [parameters json:NO];
    NSURL *url = [NSURL URLWithString:apiPath];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * value = nil;
    
    for(NSString *key in requestHeaders) {
        value = [requestHeaders objectForKey:key];
        [urlRequest setValue:value forHTTPHeaderField:key];
    };
    
    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [urlRequest setHTTPMethod:method];
    
    if([self requestNeedsBody:method]) {
        [urlRequest setHTTPBody: requestData];
    }
    
    return urlRequest;
}

-(BOOL) requestNeedsBody:(NSString *)method {
    return [method caseInsensitiveCompare:@"POST"] || [method caseInsensitiveCompare:@"PUT"];
}

@end
