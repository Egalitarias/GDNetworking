//
//  GDViewController.m
//  GDNetworking
//
//  Created by Gary Davies on 25/04/2014.
//  Copyright (c) 2014 Gary Davies. All rights reserved.
//

#import "GDViewController.h"

@interface GDViewController ()

@end

@implementation GDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    GDRequest *request = [[GDRequest alloc] init];
    
    NSDictionary *dictionary = @{@"url" : _urlTextField.text, @"method" : @"GET"};
    [request submitRequestUsingDictionary:dictionary delegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(void)update {
    
}

-(void)successUpdate:(NSDictionary *)request response:(NSDictionary *)response {
    NSNumber *statusCodeNumber = [response objectForKey:@"statusCode"];
    int statusCode = [statusCodeNumber intValue];
    NSString *text = [[NSString alloc] initWithFormat:@"Success: %d", statusCode];
    [_statusCodeTextView setText:text];
    
    NSDictionary *body = [response objectForKey:@"body"];
    text = [[NSString alloc] initWithFormat:@"Success: %@", body];
    [_responseTextView setText:text];
    
}

-(void)failUpdate:(NSDictionary *)request response:(NSDictionary *)response error:(NSError *)error {
    NSNumber *statusCodeNumber = [response objectForKey:@"statusCode"];
    int statusCode = [statusCodeNumber intValue];
    NSString *text = [[NSString alloc] initWithFormat:@"Fail: %d", statusCode];
    [_statusCodeTextView setText:text];
}

@end
