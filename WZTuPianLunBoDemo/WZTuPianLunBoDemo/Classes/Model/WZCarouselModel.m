//
//  WZCarouselModel.m
//  WZTuPianLunBoDemo
//
//  Created by songbiwen on 2016/11/25.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZCarouselModel.h"

@implementation WZCarouselModel
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
