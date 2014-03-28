//
//  TLDataCenter.m
//  GeoManager
//
//  Created by shoujun xue on 3/1/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import "TLDataCenter.h"
#import "TLConstantClass.h"

@implementation TLDataCenter

-(NSDictionary *)infoNameInfoDict
{
    NSDictionary *infoDict = @{
                               K_GROUPS:@"工作队组",
                               K_WORKING_SUFACES: @"工作面",
                      K_SHIFTS: @"班次",
                      K_TUNNELS: @"巷道名称",
                      K_OBSERVER_POINTS: @"观测点",
                      K_STRATUMS: @"煤岩层",
                      K_OBSERVER_INFO: @"观测情况",
                      K_TEAM_MEMBERS: @"汇报人",
                               K_TEAM:@"工作队组"};
    return infoDict;
}
-(NSArray *)coalSeamLevelArray
{
    NSArray *array = @[@"顶板", @"掌子面", @"底板"];
    return array;
}

-(void)initCoalSeamData
{
    NSMutableArray *_dataArrayRoof = [[NSMutableArray alloc] init];
    NSDictionary *data_t = @{K_STRATUM_ID:@"", K_NAME: @"", K_VALUE:@""};
    NSMutableDictionary *data = [data_t mutableCopy];
    [_dataArrayRoof addObject:data];
    
    NSMutableArray *_dataArrayTunnel = [[NSMutableArray alloc] init];
    NSMutableDictionary *data2 = [data_t mutableCopy];
    [_dataArrayTunnel addObject:data2];
    
    NSMutableArray *_dataArrayFloor = [[NSMutableArray alloc] init];
    NSMutableDictionary *data3 = [data_t mutableCopy];
    [_dataArrayFloor addObject:data3];
    
    self.coalSeamData = [[NSMutableArray alloc] init];
    [self.coalSeamData addObject:_dataArrayRoof];
    [self.coalSeamData addObject:_dataArrayTunnel];
    [self.coalSeamData addObject:_dataArrayFloor];
}

#pragma mark - singleton
static TLDataCenter *dataCenter;
+(TLDataCenter *)shareInstance
{
    @synchronized(self) {
        if (dataCenter == Nil) {
            dataCenter = [[self alloc] init];
        }
    }
    return dataCenter;
}

- (id)init
{
    self = [super init];
    if (self) {
        // do something
        [self initCoalSeamData];
    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (dataCenter == nil) {
            dataCenter = [super allocWithZone:zone];
            return dataCenter;
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
