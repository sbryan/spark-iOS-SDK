//
//  MeshImportTask.m
//  Spark-sdk-demo
//
//  Created by Tomer Har Yoffi on 7/8/15.
//  Copyright (c) 2015 Tomer Har Yoffi. All rights reserved.
//

#import "MeshImportTask.h"
#import "Utils.h"
#import "Constants.h"
#import "SparkLogicManager.h"
#import <UIKit/UIKit.h>

@implementation MeshImportTask 

-(instancetype)initWithMeshImportRequest:(MeshImportRequest*)meshImportRequest
                                 success:(SparkSuccessBlock)success
                                 failure:(SparkFailureBlock)failure{
    self = [super init];
    if (self) {
        _succes = success;
        _failure = failure;
        _meshImportRequest = meshImportRequest;
    }
    return self;
}

-(void)executeApiCall{
    NSMutableString * urlStr = [NSMutableString string];
    [urlStr appendString:[Utils getBaseURL]];
    [urlStr appendString:@"/"];
    [urlStr appendString:API_MESH_IMPORT];
    
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:_meshImportRequest.fileId forKey:@"file_id"];
    [jsonDict setObject:_meshImportRequest.name forKey:@"name"];
    [jsonDict setObject:_meshImportRequest.transform forKey:@"transform"];
    NSString * generateVisual = _meshImportRequest.generateVisual ? @"true" : @"false";
    [jsonDict setObject:generateVisual forKey:@"file_id"];

    NSError *error;
    NSString *jsonString = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSData * encodeData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:encodeData];
    
    //headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [[SparkLogicManager sharedInstance] accessToken]] forHTTPHeaderField:@"Authorization"];
    

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSDictionary *JSON =
                               [NSJSONSerialization JSONObjectWithData: data
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &error];
                               
                               if (JSON) {
                                   
                                  
                                   _succes(nil);
                               }else{
                                   _failure(error.localizedDescription);
                               }
                           }];
}

@end
