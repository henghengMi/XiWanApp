//
//  AddPersonController.h
//  JustDoIt
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "Person.h"
@class AddPersonController;

@protocol AddPersonControllerDelegate <NSObject>

- (void)AddPersonController:(AddPersonController *)controller person:(Person *)person;

@end

@interface AddPersonController : BasicViewController


@property(nonatomic,weak) id <AddPersonControllerDelegate> delegate;

@end
