//
//  AddViewController.h
//  GCTodoList
//
//  Created by Gustavo Couto on 2016-05-17.
//  Copyright © 2016 Gustavo Couto. All rights reserved.
//

#import "ViewController.h"
#import "GCTodo.h"

@protocol AddViewControllerDelegate <NSObject>
- (void)didAddTask:(GCTodo *)todo;
@end

@interface AddViewController : ViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id<AddViewControllerDelegate> delegate;

@end
