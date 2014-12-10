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
    IBOutlet UIView *drinkIngredientView1;
    IBOutlet UIView *drinkIngredientView2;
    IBOutlet UIView *drinkIngredientView3;
    IBOutlet UIView *drinkIngredientView4;
    IBOutlet UIView *drinkIngredientView5;
    NSMutableArray *drinkList;
}

@end

@implementation BTDrinkSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    drinkList = [[NSMutableArray alloc] initWithArray:[[BTDrinkManager sharedInstance] getDrinkList]];
    [drinkSelectionCollectionView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buildDrink:(id)sender{
    //build drink given the list
    [[BTDrinkManager sharedInstance] buildDrinkFromList];
}

#pragma mark animation and core graphics helper methods

- (void)animateAndShrinkCell:(BTDrinkCell *)cell{
    UIView *currentIngredientView;
    switch ([[[BTDrinkManager sharedInstance] getSelectedDrinkList] count]) {
        case 1:
            currentIngredientView = drinkIngredientView1;
            break;
        case 2:
            currentIngredientView = drinkIngredientView2;
            break;
        case 3:
            currentIngredientView = drinkIngredientView3;
            break;
        case 4:
            currentIngredientView = drinkIngredientView4;
            break;
        case 5:
            currentIngredientView = drinkIngredientView5;
            break;
        default:
            break;
    }
    cell.titleTextView.alpha = 0.0;
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:[drinkSelectionCollectionView convertRect:cell.frame toView:self.view]];
    cellImageView.image = [self imageWithView:cell];
    [self.view addSubview:cellImageView];
    [self.view insertSubview:cellImageView belowSubview:currentIngredientView];
    currentIngredientView.backgroundColor = cell.backgroundColor;
    cell.hidden = true;
    [UIView animateWithDuration:.5 animations:^{
        cellImageView.center = drinkIngredientView1.center;
    } completion:^(BOOL finished) {
        //remove the cell from the collection view
        [self removeCellAnimated:cell];
        [UIView animateWithDuration:.1 animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.1, 1.1);
            [cellImageView setTransform:scaleTransform];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 animations:^{
                currentIngredientView.hidden = false;
                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(.2, .2);
                [cellImageView setTransform:scaleTransform];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
                    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.1, 1.1);
                    [currentIngredientView setTransform:scaleTransform];
                } completion:^(BOOL finished) {
                    [cellImageView removeFromSuperview];
                }];
            }];
        }];
    }];
}

- (void)removeCellAnimated:(BTDrinkCell *)cell{
    NSIndexPath *targetPath = [drinkSelectionCollectionView indexPathForCell:cell];
    [drinkList removeObjectAtIndex:targetPath.row];
    [drinkSelectionCollectionView deleteItemsAtIndexPaths:@[targetPath]];
    
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [drinkList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTDrink *drink = [drinkList objectAtIndex:indexPath.row];
    BTDrinkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"drinkItem" forIndexPath:indexPath];
    cell.backgroundColor = drink.color;
    cell.titleTextView.text = drink.name;
    return cell;
}

#pragma mark collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[BTDrinkManager sharedInstance] addDrinkToSelectedList:[drinkList objectAtIndex:indexPath.row]];
    [createDrinkButton setHidden:false];
    [self animateAndShrinkCell:(BTDrinkCell*)[collectionView cellForItemAtIndexPath:indexPath]];
}

@end
