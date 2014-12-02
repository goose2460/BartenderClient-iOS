//
//  BTDrinkManager.h
//  bartenderClient
//
//  Created by Davis Gossage on 12/1/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDrinkManager : NSObject

+ (BTDrinkManager*)sharedInstance;
-(NSArray*)getDrinkList;

@end
