//
//  GCTodo.h
//  GCTodoList
//
//  Created by Gustavo Couto on 2016-05-17.
//  Copyright © 2016 Gustavo Couto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCTodo : NSObject


//Create a Todo object which has the following properties:
//title
@property (copy, nonatomic) NSString* title;
//description
@property (copy, nonatomic) NSString* desc;
//priority number
@property (assign, nonatomic) NSUInteger priorityNum;
//is completed indicator
@property (assign, nonatomic) BOOL isCompleted;

@property (strong, nonatomic) NSDate* deadLine;



@end
