//
//  Plan.h
//  TwoWeekClear
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 Maybe There. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plan : NSObject
@property NSString *textContent;
@property int numberText;
@property BOOL onOff;
@property NSString *createAtDate;
@property int rowID;
@property int year;
@property int month;
@property int day;
@end
