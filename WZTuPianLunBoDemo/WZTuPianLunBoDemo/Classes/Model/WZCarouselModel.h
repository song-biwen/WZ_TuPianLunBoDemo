//
//  WZCarouselModel.h
//  WZTuPianLunBoDemo
//
//  Created by songbiwen on 2016/11/25.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

//轮播数据模型
@interface WZCarouselModel : NSObject
/*
 "title":"沈阳毕业生双选会场面火爆 万余人参加",
 "tag":"photoset",
 "subtitle":"",
 "imgsrc":"http://cms-bucket.nosdn.127.net/e82a5892ed9947a0957ec7f6888203cf20161125074924.jpeg",
 "url":"00AP0001|2214925"
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imgsrc;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
@end
