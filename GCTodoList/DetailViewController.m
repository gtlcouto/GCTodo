//
//  DetailViewController.m
//  GCTodoList
//
//  Created by Gustavo Couto on 2016-05-17.
//  Copyright © 2016 Gustavo Couto. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem.titleView setHidden:YES];
    self.navigationItem.rightBarButtonItem = nil;



    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 200, 50)];
    titleLabel.text = self.todo.title;
    [self.view addSubview:titleLabel];

    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 160, 200, 50)];
    detailLabel.text = self.todo.desc;
    detailLabel.numberOfLines = 6;
    [self.view addSubview:detailLabel];

    UILabel* priorityLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 220, 100, 50)];
    priorityLabel.text = [NSString stringWithFormat:@"%d", self.todo.priorityNum];
    [self.view addSubview:priorityLabel];

    if(self.todo.isCompleted)
        self.view.backgroundColor = [UIColor greenColor];
    else
        self.view.backgroundColor = [UIColor redColor];
}



@end
