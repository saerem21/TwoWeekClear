//
//  OrderCell.h
//  CoffeeOrder
//
//  Created by SDT-1 on 2014. 1. 15..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlanDelegate.h"
@interface OrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UISwitch *onOff;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic)id<PlanDelegate> delegate;

@end
