//
//  ShDatabase.m
//  Sharc
//
//  Created by Clay Jones on 7/28/16.
//  Copyright © 2016 Transactive. All rights reserved.
//

#import "ShDatabase.h"

//const NSString *urlString = @"http://localhost:5000/api/";
const NSString *urlString = @"https://mysterious-stream-72025.herokuapp.com/api/";

@implementation ShDatabase

+ (void) getDealsWithBlock:(void (^)(NSArray *data))block {
    [self makeGETRequestToEndpoint:@"deal/list" withBodyData:@{} withBlock:^(NSData *data) {
        NSError *error;
        if (!data || error) {
            block( @[@{
                     @"success":@0,
                     @"status":@-1
                     }]);
            return;
        }
        NSArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        block(dictionary);
        NSLog(@"Data from posts: %@",dictionary);
    }];
}

+(void) getImageForDealID: (NSString *) dealID withBlock: (void (^)(UIImage *image))block{
    NSString *urlEndpoint = [NSString stringWithFormat:@"deal/%@/photo",dealID];
    [self makeGETRequestToEndpoint:urlEndpoint withBodyData:@{} withBlock:^(NSData *data) {
        NSError *error;
        if (!data || error) {
            block(nil);
            return;
        }
        UIImage *image = [UIImage imageWithData:data];
        block(image);
    }];
}

+(void) getMerchantForID: (NSString *) merchantID withBlock: (void (^)(NSDictionary *dict))block{
    NSString *urlEndpoint = [NSString stringWithFormat:@"merchant/%@",merchantID];
    [self makeGETRequestToEndpoint:urlEndpoint withBodyData:@{} withBlock:^(NSData *data) {
        NSError *error;
        if (!data || error) {
            block(nil);
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        block(dictionary);
    }];
}

+ (void)makePOSTRequestToEndpoint:(NSString *)url withBodyData:(NSDictionary *)data withBlock:(void (^)(NSData *data))block {
        NSString *completeURL = [NSString stringWithFormat: @"%@%@",urlString, url];
        NSLog(@"%@", completeURL);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]];
        NSURLSession *session = [NSURLSession sharedSession];
        
        // Specify that it will be a POST request
        request.HTTPMethod = @"POST";
        NSData *postData = [self encodeDictionary:data];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = postData;
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            block(data);
        }];
        
        [task resume];
}

+ (void)makeGETRequestToEndpoint:(NSString *)url withBodyData:(NSDictionary *)data withBlock:(void (^)(NSData *data))block {
    NSString *completeURL = [NSString stringWithFormat: @"%@%@",urlString, url];
    NSLog(@"%@", completeURL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"GET";
    NSData *postData = [self encodeDictionary:data];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = postData;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        block(data);
    }];
    
    [task resume];
}

+ (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue;
        if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]]) {
            encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            encodedValue = [[NSString stringWithFormat:@"%@",[dictionary objectForKey:key]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

@end
