//
//  ViewController.m
//  GCTodoList
//
//  Created by Gustavo Couto on 2016-05-17.
//  Copyright © 2016 Gustavo Couto. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import "GCTodo.h"

@interface ViewController () <AddViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) UISegmentedControl* filter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateData];
    [self addButtonToNavBar];
    [self addSwipeToCrossOut];
    [self addLongPressToEdit];
    [self addSegmentedControlToNavBar];
    [self randomizeArrayIndex];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self deselectRow];
}



#pragma mark - Helper Methods
-(void)randomizeArrayIndex
{
    for (int i = 0; i < self.data.count; i++) {
        int randomInt1 = arc4random() % [self.data count];
        int randomInt2 = arc4random() % [self.data count];
        [self.data exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
}
-(void)deselectRow
{
    NSIndexPath *indexPath = self.myTableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)addSegmentedControlToNavBar
{
    self.filter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Priority", @"Deadline", nil]];
    [self.filter sizeToFit];
    self.navigationItem.titleView = self.filter;
    [self.filter addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)filterChanged:(id)sender
{
    if(self.filter.selectedSegmentIndex == 0) //Priority
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priorityNum"
                                                     ascending:YES];
        self.data = [[self.data sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];

    } else //Deadline
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"deadLine"
                                                     ascending:YES];
        self.data = [[self.data sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    }
    [self.myTableView reloadData];
}

-(void)addLongPressToEdit
{
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(turnEditOn:)];
    [longPress setMinimumPressDuration:2.0];
    [self.myTableView addGestureRecognizer:longPress];
}

-(void)turnEditOn:(UIGestureRecognizer* )gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
        [self.myTableView setEditing:!self.myTableView.isEditing];
}

-(void)addSwipeToCrossOut
{
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(crossOut:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.myTableView addGestureRecognizer:swipeGesture];
}

-(void)crossOut:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.myTableView];
    NSIndexPath *swipedIndexPath = [self.myTableView indexPathForRowAtPoint:location];
    GCTodo* currTodo = [self.data objectAtIndex:swipedIndexPath.row];
    currTodo.isCompleted = !currTodo.isCompleted;
    [self.myTableView reloadData];
}

-(void)addButtonToNavBar
{
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(createNewTodo)];
    self.navigationItem.rightBarButtonItem = barButton;
}


-(void)populateData
{
    self.data = [[NSMutableArray alloc] init];
    for (int x = 0; x < 20; x++)
    {
        GCTodo* todo = [[GCTodo alloc] init];
        todo.title = @"Clean House";
        todo.desc = @"Clean the floors using special product";
        todo.priorityNum = x;
        todo.isCompleted = true;
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:x];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        todo.deadLine = newDate; //+1 MONTH FOR EVERY LOOP
        if(x % 2 == 0)
        {
            todo.isCompleted = false;
        }
        [self.data addObject:todo];
    }


}

-(void)createNewTodo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddViewController* addVC = [storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    addVC.delegate = self;


    [self.navigationController presentViewController:addVC animated:YES completion:nil];

}

-(void)didAddTask:(GCTodo *)todo
{
    [self.data addObject:todo];
    [self.myTableView reloadData];
}


#pragma mark - Segue Methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailSegue"])
    {
        if ([segue.destinationViewController respondsToSelector:@selector(setTodo:)]) {
            [segue.destinationViewController performSelector:@selector(setTodo:)
                                                  withObject:[self.data objectAtIndex:self.myTableView.indexPathForSelectedRow.row]];



            NSLog(@"Sent Data to Detail VC");

        }
    }
}


#pragma mark - Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    GCTodo * todo = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = nil;
    cell.textLabel.text = todo.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %lu \tDetail: %@", (unsigned long)todo.priorityNum, todo.desc];

    if(todo.isCompleted)
    {
        cell.backgroundColor = [UIColor greenColor];
        NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc] initWithString:todo.title];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = attributeString;
        
    } else
    {
        cell.backgroundColor = [UIColor redColor];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    [self.data removeObjectAtIndex:indexPath.row];
    [self.myTableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    GCTodo* currTodo = [self.data objectAtIndex:sourceIndexPath.row];
    [self.data removeObjectAtIndex:sourceIndexPath.row];
    [self.data insertObject:currTodo atIndex:destinationIndexPath.row];
}
@end
