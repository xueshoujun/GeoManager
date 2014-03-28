//
//  TLDataCenter.h
//  GeoManager
//
//  Created by shoujun xue on 3/1/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLDataCenter : NSObject
@property(strong, nonatomic)NSString *accessToken;
@property(strong, nonatomic)NSMutableArray *coalSeamData;
-(NSDictionary *)infoNameInfoDict;
-(NSArray *)coalSeamLevelArray;
-(void)initCoalSeamData;
+(TLDataCenter *)shareInstance;

@end
