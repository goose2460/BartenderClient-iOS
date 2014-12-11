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
#import "BTSavedDrinkCell.h"

@interface BTDrinkSelectionViewController (){
    IBOutlet UICollectionView *drinkSelectionCollectionView;
    IBOutlet UICollectionView *savedDrinkCollectionView;
    IBOutlet UIButton *createDrinkButton;
    IBOutlet UIView *drinkIngredientBoundingView;
    IBOutlet UIView *drinkIngredientView1;
    IBOutlet UIView *drinkIngredientView2;
    IBOutlet UIView *drinkIngredientView3;
    IBOutlet UIView *drinkIngredientView4;
    IBOutlet UIView *drinkIngredientView5;
    NSMutableArray *drinkList;
    NSMutableArray *savedDrinkList;
}

@end

@implementation BTDrinkSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    drinkList = [[NSMutableArray alloc] initWithArray:[[BTDrinkManager sharedInstance] getDrinkList]];
    savedDrinkList = [[NSMutableArray alloc] initWithArray:[[BTDrinkManager sharedInstance] getSavedDrinkList]];
    [drinkSelectionCollectionView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buildDrink:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name your drink:"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Build"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    [[BTDrinkManager sharedInstance] buildDrinkFromList];
    //hack since views with transparent backgrounds save as black
    drinkIngredientBoundingView.backgroundColor = [UIColor whiteColor];
    [[BTDrinkManager sharedInstance] saveDrinkFromListToStorageWithImage:[self imageWithView:drinkIngredientBoundingView] andName:[alertView textFieldAtIndex:0].text];
    drinkIngredientBoundingView.backgroundColor = [UIColor clearColor];
    [self resetDrinkViews];
}

- (void)resetDrinkViews{
    savedDrinkList = [[NSMutableArray alloc] initWithArray:[[BTDrinkManager sharedInstance] getSavedDrinkList]];
    [savedDrinkCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    [UIView animateWithDuration:.5 animations:^{
        drinkIngredientView1.alpha = 0.0;
        drinkIngredientView2.alpha = 0.0;
        drinkIngredientView3.alpha = 0.0;
        drinkIngredientView4.alpha = 0.0;
        drinkIngredientView5.alpha = 0.0;
    }];
    [createDrinkButton setHidden:true];
    drinkList = [[NSMutableArray alloc] initWithArray:[[BTDrinkManager sharedInstance] getDrinkList]];
    [drinkSelectionCollectionView reloadData];
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
    [self.view insertSubview:cellImageView belowSubview:drinkIngredientBoundingView];
    currentIngredientView.backgroundColor = cell.backgroundColor;
    cell.hidden = true;
    [UIView animateWithDuration:.5 animations:^{
        cellImageView.center = [drinkIngredientBoundingView convertPoint:drinkIngredientView1.center toView:self.view];
    } completion:^(BOOL finished) {
        //remove the cell from the collection view
        [self removeCellAnimated:cell];
        [UIView animateWithDuration:.1 animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.1, 1.1);
            [cellImageView setTransform:scaleTransform];
        } completion:^(BOOL finished) {
            currentIngredientView.alpha = 1.0;
            [UIView animateWithDuration:.5 animations:^{
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

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == savedDrinkCollectionView){
        return CGSizeMake(self.view.frame.size.width, 110);
    }
    else{
        return CGSizeMake(125.0, 125.0);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == savedDrinkCollectionView){
        return [savedDrinkList count];
    }
    else if (collectionView == drinkSelectionCollectionView){
        return [drinkList count];
    }
    else{
        return 0;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == savedDrinkCollectionView){
        BTSavedDrinkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"savedDrinkItem" forIndexPath:indexPath];
        NSDictionary *drinkInfo = [savedDrinkList objectAtIndex:indexPath.row];
        cell.drinkName.text = [drinkInfo objectForKey:@"name"];
        cell.drinkImageView.image = [drinkInfo objectForKey:@"image"];
        return cell;
    }
    else if (collectionView == drinkSelectionCollectionView){
        BTDrink *drink = [drinkList objectAtIndex:indexPath.row];
        BTDrinkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"drinkItem" forIndexPath:indexPath];
        cell.backgroundColor = drink.color;
        cell.titleTextView.text = drink.name;
        return cell;
    }
    else{
        return NULL;
    }
}

#pragma mark collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == drinkSelectionCollectionView){
        [[BTDrinkManager sharedInstance] addDrinkToSelectedList:[drinkList objectAtIndex:indexPath.row]];
        [createDrinkButton setHidden:false];
        [self animateAndShrinkCell:(BTDrinkCell*)[collectionView cellForItemAtIndexPath:indexPath]];
    }
}

@end
