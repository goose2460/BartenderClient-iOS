//
//  BTDrinkSelectionViewController.m
//  bartenderClient
//
//  Created by Davis Gossage on 12/1/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTDrinkSelectionViewController.h"
#import "UIColor+BTPalette.h"
#import "BTDrinkCell.h"
#import "BTDrinkManager.h"
#import "BTDrink.h"

@interface BTDrinkSelectionViewController (){
    IBOutlet UICollectionView *drinkSelectionCollectionView;
    IBOutlet UIButton *createDrinkButton;
}

@end

@implementation BTDrinkSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[BTDrinkManager sharedInstance] getDrinkList] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTDrink *drink = [[[BTDrinkManager sharedInstance] getDrinkList] objectAtIndex:indexPath.row];
    BTDrinkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"drinkItem" forIndexPath:indexPath];
    cell.backgroundColor = drink.color;
    cell.titleTextView.text = drink.name;
    return cell;
}

#pragma mark collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *drinkList = [[BTDrinkManager sharedInstance] getDrinkList];
    [[BTDrinkManager sharedInstance] addDrinkToSelectedList:[drinkList objectAtIndex:indexPath.row]];
    [createDrinkButton setTitle:[NSString stringWithFormat:@"Create %d Ingredient Drink",[[[BTDrinkManager sharedInstance] getSelectedDrinkList] count]] forState:UIControlStateNormal];
    
}

@end
