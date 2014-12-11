//
//  BTDrinkManager.m
//  bartenderClient
//
//  Created by Davis Gossage on 12/1/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTDrinkManager.h"
#import "UIColor+BTPalette.h"
#import "BTBluetoothManager.h"

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

-(void)buildDrinkFromList{
    //encode the list to comma separated
    NSMutableArray *drinkCodes = [NSMutableArray new];
    for (BTDrink *d in selectedDrinkArray){
        [drinkCodes addObject:[NSNumber numberWithInteger:d.identifier]];
    }
    [drinkCodes sortUsingSelector:@selector(compare:)];
    NSString *finalDataString = [NSString stringWithFormat:@"%@*", [drinkCodes componentsJoinedByString:@","]];
    [[BTBluetoothManager sharedInstance] writeStringData:finalDataString];
    //TODO: error handle
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your drink is being created." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [selectedDrinkArray removeAllObjects];
}

-(NSArray*)getSavedDrinkList{
    NSMutableArray *arrayFromStorage = [NSMutableArray new];
    [arrayFromStorage addObjectsFromArray:
    [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDrinks"]];
    for (int i = 0; i<arrayFromStorage.count; i++){
        NSMutableDictionary *mutableDrinkInfo = [[NSMutableDictionary alloc] initWithDictionary:[arrayFromStorage objectAtIndex:i]];
        [mutableDrinkInfo setValue:[UIImage imageWithData:[[arrayFromStorage objectAtIndex:i] valueForKey:@"imageData"]] forKey:@"image"];
        [arrayFromStorage replaceObjectAtIndex:i withObject:mutableDrinkInfo];
    }
    return arrayFromStorage;
}

-(void)saveDrinkFromListToStorageWithImage:(UIImage *)image andName:(NSString *)name{
    NSArray *drinksFromStorage = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDrinks"];
    if (!drinksFromStorage){
        drinksFromStorage = [NSArray new];
    }
    NSMutableArray *savedDrinks = [[NSMutableArray alloc] initWithArray:drinksFromStorage];
    [savedDrinks insertObject:@{@"imageData":UIImagePNGRepresentation(image),@"name":name} atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:savedDrinks] forKey:@"savedDrinks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
