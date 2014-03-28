//
//  TLServiceRequest.m
//  GeoManager
//
//  Created by shoujun xue on 2/26/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//


#import "TLServiceRequest.h"
#import "TLConstantClass.h"
#import "AFNetworking.h"
#import "TLAlertView.h"
#import "TLDataCenter.h"

@implementation TLServiceRequest

-(void)groupRequest:(NSDictionary *)groupRequest
{
    NSURL *url = [NSURL URLWithString:URL_REQUEST_GROUP];
    AFHTTPClient *httpClinet = [AFHTTPClient clientWithBaseURL:url];
    [httpClinet setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *urlRequest = [httpClinet requestWithMethod:@"GET" path:@"" parameters:groupRequest];
    
    // AFHTTPRequest
    AFHTTPRequestOperation *httpRequest = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [httpRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 返回结果
        NSDictionary *groupDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        // MOCK
//        NSDictionary *groupDict = [self groupMockResponse];
        
        if (_startDelegate && [_startDelegate respondsToSelector:@selector(groupResponse:)]) {
            [_startDelegate groupResponse:groupDict];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"group request failure URL : %@", operation.request.URL.absoluteString);
        NSLog(@"group request failure error : %@", error.debugDescription);
        // 返回失败的结果
        NSString *errorMessage = [NSString stringWithFormat:NSLocalizedString(@"alertNotGetGroup", nil), error.code];
        NSDictionary *resultDict = @{K_REQUEST_RESULT: K_REQUEST_RESULT_FAILURE, K_REQUEST_RESULT_MESSAGE: errorMessage};

        if (_startDelegate && [_startDelegate respondsToSelector:@selector(groupResponse:)]) {
            [_startDelegate groupResponse:resultDict];
        }
        
    }];
    [httpRequest start];
}

/* 备用：
 // AFJSONRequest
 AFJSONRequestOperation *jsonRequest = [[AFJSONRequestOperation alloc] initWithRequest:urlRequest];
 [jsonRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"group request success %@", responseObject);
 NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
 NSLog(@"responseArray %@", responseArray);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"group request failure URL : %@", operation.request.URL.absoluteString);
 NSLog(@"group request failure error : %@", error.debugDescription);
 }];
 [jsonRequest start];
 */

-(void)loginRequest:(NSDictionary *)loginRequest
{
    NSLog(@"loginRequest %@", loginRequest);
    NSString *teamId = @"";
    if ([loginRequest[K_ID] isKindOfClass:[NSString class]]) {
        teamId = loginRequest[K_ID];
    }else {
        teamId = [loginRequest[K_ID] stringValue];
    }
    // TODO:test teamid = adming start
//    teamId = @"admin";
    // TODO:test teamid = adming end
    NSDictionary *requestDict = @{K_TEAM_ID:teamId, K_PASSWORD:loginRequest[K_PASSWORD]};
    NSURL *url = [NSURL URLWithString:URL_REQUEST_LOGIN];
    AFHTTPClient *httpClinet = [AFHTTPClient clientWithBaseURL:url];
//    [httpClinet setParameterEncoding:AFJSONParameterEncoding];
    // application/x-www-form-urlencoded
    NSMutableURLRequest *urlRequest = [httpClinet requestWithMethod:@"POST" path:@"/mtp/team/login" parameters:requestDict];
    
    // AFHTTPRequest
    AFHTTPRequestOperation *httpRequest = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [httpRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 返回结果
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        // 回调返回结果
        if (_loginDelegate && [_loginDelegate respondsToSelector:@selector(loginResponse:)]) {
            [_loginDelegate loginResponse:resultDict];
        }
        NSLog(@"login resultDict %@", resultDict);
        
        NSLog(@"requst hearder %@", operation.request.allHTTPHeaderFields);
        NSLog(@"requst string %@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"loginRequest failure URL : %@", operation.request.URL.absoluteString);
        NSLog(@"loginRequest failure error : %@", error.debugDescription);
        NSLog(@"requst hearder %@", operation.request.allHTTPHeaderFields);
        NSLog(@"requst string %@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
        NSLog(@"response string %@", operation.responseString);
        // 返回失败的结果
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"alertLoginFail", nil), operation.response.statusCode];
        if (401 == operation.response.statusCode) {
            message = NSLocalizedString(@"alertLoginFail_Password", Nil);
        }
        NSDictionary *resultDict = @{K_REQUEST_RESULT: K_REQUEST_RESULT_FAILURE, K_REQUEST_RESULT_MESSAGE: message};
//        NSDictionary *resultDict = [self loginMockResponse];
        // 回调返回结果
        if (_loginDelegate && [_loginDelegate respondsToSelector:@selector(loginResponse:)]) {
            [_loginDelegate loginResponse:resultDict];
        }
    }];
    [httpRequest start];
}

/*
 备用：现在用 [httpClinet setParameterEncoding:AFJSONParameterEncoding];
 [urlRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
 [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept-Encoding"];
 urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:nil];
 */
-(void)submitRequest:(NSDictionary *)requestDict
{
    NSLog(@"submitRequest %@", requestDict);
    NSURL *url = [NSURL URLWithString:URL_REQUEST_SUBMIT];
    AFHTTPClient *httpClinet = [AFHTTPClient clientWithBaseURL:url];
    [httpClinet clearAuthorizationHeader];
    [httpClinet setAuthorizationHeaderWithToken:[TLDataCenter shareInstance].accessToken];
    // Authorization:{accessToken}
    [httpClinet setDefaultHeader:@"Authorization" value:[TLDataCenter shareInstance].accessToken];
    [httpClinet setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *urlRequest = [httpClinet requestWithMethod:@"POST" path:@"" parameters:requestDict];
    AFHTTPRequestOperation *httpRequest = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [httpRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"requst hearder %@", operation.request.allHTTPHeaderFields);
        NSLog(@"requst string %@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
        NSLog(@"responseObject %@", responseObject);
        
        if (_submitDelegate && [_submitDelegate respondsToSelector:@selector(submitGeoInfoResponse:)]) {
            [_submitDelegate submitGeoInfoResponse:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"loginRequest failure URL : %@", operation.request.URL.absoluteString);
        NSLog(@"loginRequest failure error : %@", error.debugDescription);
        
        NSLog(@"requst hearder %@", operation.request.allHTTPHeaderFields);
        NSLog(@"requst string %@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
        
        // 返回失败的结果
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"alertSubmitFailed", nil), operation.response.statusCode];
        NSDictionary *resultDict = @{K_REQUEST_RESULT: K_REQUEST_RESULT_FAILURE, K_REQUEST_RESULT_MESSAGE: message};
        // 回调返回结果
        if (_submitDelegate && [_submitDelegate respondsToSelector:@selector(submitGeoInfoResponse:)]) {
            [_submitDelegate submitGeoInfoResponse:resultDict];
        }
        
    }];
    [httpRequest start];
}

#pragma mark - MOCK Data
-(NSDictionary *)groupMockResponse
{
    NSString *jsonStr = @"{\"success\":\"true\","
    "\"message\":\"null\","
    "\"groups\":[{\"id\":\"11\","
                "\"name\":\"综掘队\","
                "\"members\":[{\"id\":12,\"name\":\"综掘一队\"},{\"id\":\"13\",\"name\":\"综掘二队\"}]},"
    
                "{\"id\":\"21\","
                "\"name\":\"开拓队\","
                "\"teams\":[{\"id\":\"22\",\"name\":\"开拓一队\"},{\"id\":\"23\",\"name\":\"开拓二队\"},{\"id\":\"24\",\"name\":\"开拓三队\"},{\"id\":\"25\",\"name\":\"开拓四队\"},{\"id\":\"26\",\"name\":\"开拓五队\"}]},"
    
                "{\"id\":\"31\","
                "\"name\":\"开拓队2\","
                "\"teams\":[{\"id\":\"22\",\"name\":\"开拓一队\"},{\"id\":\"23\",\"name\":\"开拓二队\"},{\"id\":\"24\",\"name\":\"开拓三队\"},{\"id\":\"25\",\"name\":\"开拓四队\"}]},"
    
                "{\"id\":\"41\","
                "\"name\":\"开拓队3\","
                "\"teams\":[{\"id\":\"22\",\"name\":\"开拓一队\"},{\"id\":\"23\",\"name\":\"开拓二队\"},{\"id\":\"24\",\"name\":\"开拓三队\"}]},"
    
                "{\"id\":\"51\","
                "\"name\":\"开拓队4\","
                "\"teams\":[{\"id\":\"22\",\"name\":\"开拓一队\"},{\"id\":\"23\",\"name\":\"开拓二队\"},{\"id\":\"24\",\"name\":\"开拓三队\"},{\"id\":\"25\",\"name\":\"开拓四队\"},{\"id\":\"26\",\"name\":\"开拓五队\"},{\"id\":\"57\",\"name\":\"开拓六队\"}]},"
    
                "{\"id\":\"61\","
                "\"name\":\"开拓队5\","
                "\"teams\":[{\"id\":\"22\",\"name\":\"开拓一队\"},{\"id\":\"23\",\"name\":\"开拓二队\"},{\"id\":\"24\",\"name\":\"开拓三队\"},{\"id\":\"25\",\"name\":\"开拓四队\"},{\"id\":\"26\",\"name\":\"开拓五队\"},{\"id\":\"57\",\"name\":\"开拓六队\"},{\"id\":\"58\",\"name\":\"开拓七队\"}]}"
    
                "]"
    "}";
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:Nil];
    NSLog(@"groups %@", jsonDict[@"groups"]);
    return jsonDict;
}
-(NSDictionary *)loginMockResponse
{
    NSString *jsonStr = @"{"
    "\"success\":\"true\","
    "\"message\":\"null\","
    "\"serverTime\":\"2014-03-01\","
    "\"accessToken\":\"qweiurpqewuripqwrue\","
    "\"team\":{\"id\":\"1\",\"name\":\"综掘一队\",\"members\":[{\"id\":\"11\",\"name\":\"张三\"},{\"id\":\"12\",\"name\":\"李四\"}]},"
    "\"shifts\":[{\"id\":\"1\",\"name\":\"早班\"},{\"id\":\"2\",\"name\":\"中班\"},{\"id\":\"3\",\"name\":\"晚班\"}],"
    "\"surfaces\":[{\"id\":\"1\","
                        "\"name\":\"28111切眼\", "
                     "\"tunnels\":[{\"id\":\"12\","
                                    "\"name\":\"28111切眼左\", "
                                    "\"points\":[{\"id\":\"124\",\"name\":\"A\"},{\"id\":\"125\",\"name\":\"B\"}]},"
    
                                    "{\"id\":\"13\","
                                    "\"name\":\"28112切眼右\", "
                                    "\"points\":[{\"id\":\"134\",\"name\":\"C\"},{\"id\":\"135\",\"name\":\"D\"}]}]}, "
    
                        "{\"id\":\"2\","
                        "\"name\":\"28112切眼\", "
                        "\"tunnels\":[{\"id\":\"22\","
                                    "\"name\":\"28112切眼Left\","
                                    "\"points\":[{\"id\":\"224\",\"name\":\"E\"},{\"id\":\"225\",\"name\":\"F\"}]},"
    
                                    "{\"id\":\"23\","
                                    "\"name\":\"28112切眼Right\","
                                    "\"points\":[{\"id\":\"234\",\"name\":\"G\"},{\"id\":\"235\",\"name\":\"H\"}]}]}],"
    
    
    "\"stratums\":[{\"id\":\"6\",\"name\":\"泥岩\"},{\"id\":\"7\",\"name\":\"灰岩\"},{\"id\":\"8\",\"name\":\"煤层\"}],"
    "\"infos\":[{\"id\":\"9\",\"name\":\"无异常\"},{\"id\":\"10\",\"name\":\"渗水\"}]"
    "}";
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:Nil];
    NSLog(@"login %@", jsonDict);
    return jsonDict;

}

#pragma mark - Singleton
static TLServiceRequest *serviceRequest;
+ (TLServiceRequest *)shareInstance
{
    @synchronized(self){
        if (serviceRequest == nil) {
            serviceRequest = [[self alloc] init];
        }
    }
    return serviceRequest;
}
- (id)init
{
    self = [super init];
    if (self) {
        // do something
    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (serviceRequest == nil) {
            serviceRequest = [super allocWithZone:zone];
            return serviceRequest;
        }
    }
    return nil;
}

+(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)copy
{
    return self;
}
@end
