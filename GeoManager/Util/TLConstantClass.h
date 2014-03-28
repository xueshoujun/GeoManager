//
//  TLConstantClass.h
//  GeoManager
//
//  Created by shoujun xue on 2/24/14.
//  Copyright (c) 2014 shoujun xue. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL_REQUEST_GROUP   @"http://112.124.102.24:8080/mtp/team"
#define URL_REQUEST_LOGIN   @"http://112.124.102.24:8080/mtp/team/login"
//#define URL_REQUEST_LOGIN   @"http://112.124.102.24:8080/mtp/form/conf"
#define URL_REQUEST_SUBMIT  @"http://112.124.102.24:8080/mtp/form/save"

#define URL_NOTIFICATION    @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=26022338a38b87d65042ac1f33302838/6c224f4a20a446239ce9346b9a22720e0cf3d79c.jpg"

#define K_NAME      @"name"
#define K_ID        @"id"
#define K_TEAMS     @"teams"
#define K_VALUE     @"value"
#define K_PASSWORD  @"password"
#define K_ACCESS_TOKEN      @"accessToken"


#define K_GROUPS            @"groups"
#define K_SERVER_TIME       @"serverTime"
#define K_WORKING_SUFACES   @"surfaces"
#define K_SHIFTS            @"shifts"
#define K_TEAM              @"team"
#define K_TEAM_MEMBERS      @"members"
#define K_TUNNELS           @"tunnels"
#define K_OBSERVER_POINTS   @"points"
#define K_OBSERVER_INFO     @"infos"
#define K_STRATUMS          @"stratums"

#define K_TEAM_ID           @"teamId"
#define K_REPORTER_ID       @"reporter"
#define K_SURFACE_ID        @"surfaceId"
#define K_SHIFT_ID          @"shiftId"
#define K_TUNNEL_ID         @"tunnelId"
#define K_POINT_ID          @"pointId"
#define K_POINT_AHEAD       @"pointAhead"
#define K_STRATUM_ARRAY     @"stratum"
#define K_ROOF_ARRAY        @"roof"
#define K_TUNNEL_ARRAY      @"tunnel"
#define K_FLOOR_ARRAY       @"floor"
#define K_STRATUM_ID        @"stratumId"
#define K_VALUE             @"value"
#define K_ROOF_ANCHOR       @"roofAnchor"
#define K_AHEAD_HOLE        @"aheadHole"
#define K_TUNNEL_INFO       @"tunnelInfo"

#define K_REQUEST_RESULT            @"result"
#define K_REQUEST_RESULT_MESSAGE    @"message"
#define K_REQUEST_RESULT_FAILURE    @"failure"


#define TAG_COAL_SEAM_TEXTFIELD         101
#define TAG_COAL_SEAM_VALUE_TEXTFIELD         102

#define COLOR_BLUE_TEXT [UIColor colorWithRed:0.2353 green:0.7137 blue:0.8832 alpha:1]
#define COLOR_BLUE_BG [UIColor colorWithRed:0.1216 green:0.4941 blue:0.7608 alpha:1]
@interface TLConstantClass : NSObject
@end
