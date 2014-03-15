//
//  TLServiceRequestLoginDelegate.h
//  GeoManager
//
//  Created by shoujun xue on 2/26/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TLServiceRequestLoginDelegate <NSObject>
-(void)loginResponse:(NSDictionary *)response;
@end
