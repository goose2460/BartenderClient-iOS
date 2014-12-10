//
//  BTDrinkCell.m
//  bartenderClient
//
//  Created by Davis Gossage on 12/1/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTDrinkCell.h"

@implementation BTDrinkCell

- (void)prepareForReuse{
    self.hidden = false;
    self.titleTextView.alpha = 1.0;
}

@end
