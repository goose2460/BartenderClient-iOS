//
//  BTDrinkManager.m
//  bartenderClient
//
//  Created by Davis Gossage on 12/1/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTDrinkManager.h"
#import "UIColor+BTPalette.h"

@implementation BTDrinkManager
static BTDrinkManager* gSharedInstance = nil;

NSMutableArray *drinkArray;
NSMutableArray *selectedDrinkArray;

+(BTDrinkManager*)sharedInstance {
    if (!gSharedInstance) {
        gSharedInstance = [[BTDrinkManager alloc] init];
    }
    return gSharedInstance;
}

-(NSArray*)getDrinkList{
    if (!drinkArray){
        drinkArray = [NSMutableArray new];
        //read in plist
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"DrinkList" ofType:@"plist"];
        
        // Build the array from the plist
        NSDictionary *drinkListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSArray *drinkFileArray = [drinkListDictionary objectForKey:@"Drinks"];
        for (NSDictionary *d in drinkFileArray){
            BTDrink *drink = [BTDrink alloc];
            drink.name = [[d objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
            SEL customColor = NSSelectorFromString([d objectForKey:@"Color"]);
            drink.color = [UIColor performSelector:customColor];
            drink.identifier = [[d objectForKey:@"Identifier"] integerValue];
            [drinkArray addObject:drink];
        }
    }
    return drinkArray;
}

- (NSArray *)getSelectedDrinkList{
    return selectedDrinkArray;
}

-(void)addDrinkToSelectedList:(BTDrink*)drink{
    if (!selectedDrinkArray){
        selectedDrinkArray = [NSMutableArray new];
    }
    if (![selectedDrinkArray containsObject:drink]){
        [selectedDrinkArray addObject:drink];
    }
}

-(void)createDrink{
    //bluetooth code here
}

@end
