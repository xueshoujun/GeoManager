//
//  TLServiceRequest.h
//  GeoManager
//
//  Created by shoujun xue on 2/26/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLServiceRequestStartDelegate.h"
#import "TLServiceRequestLoginDelegate.h"
#import "TLServiceRequestSubmitDelegate.h"

@interface TLServiceRequest : NSObject
@property (assign, nonatomic)id<TLServiceRequestStartDelegate>startDelegate;
@property (assign, nonatomic)id<TLServiceRequestLoginDelegate>loginDelegate;
@property (assign, nonatomic)id<TLServiceRequestSubmitDelegate>submitDelegate;

-(void)groupRequest:(NSDictionary *)groupRequest;
-(void)loginRequest:(NSDictionary *)loginRequest;
-(void)submitRequest:(NSDictionary *)requestDict;

+ (TLServiceRequest *)shareInstance;
@end
