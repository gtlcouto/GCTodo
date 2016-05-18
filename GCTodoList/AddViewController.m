//
//  AddViewController.m
//  GCTodoList
//
//  Created by Gustavo Couto on 2016-05-17.
//  Copyright © 2016 Gustavo Couto. All rights reserved.
//

#import "AddViewController.h"




@interface AddViewController () 
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UISwitch *completedSwitch;
@property (strong, nonatomic) NSArray* pickerArray;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;


}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerArray[row] stringValue];
}

- (IBAction)addTaskHandler:(id)sender {
    GCTodo* todo = [GCTodo new];
    todo.title = self.titleTextField.text;
    todo.desc = self.descTextField.text;
    todo.priorityNum = [self.pickerView selectedRowInComponent:0];
    todo.isCompleted = self.completedSwitch.isSelected;
    todo.deadLine = [self.datePicker date];
    [self.delegate didAddTask:todo];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
