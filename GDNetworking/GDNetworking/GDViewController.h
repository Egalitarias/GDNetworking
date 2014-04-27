//
//  GDViewController.h
//  GDNetworking
//
//  Created by Gary Davies on 25/04/2014.
//  Copyright (c) 2014 Gary Davies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDRequest.h"

@interface GDViewController : UIViewController <GDRequestDelegate>

@property (nonatomic, weak) IBOutlet UITextField *urlTextField;
@property (nonatomic, weak) IBOutlet UITextView *statusCodeTextView;
@property (nonatomic, weak) IBOutlet UITextView *responseTextView;

-(IBAction)getButtonPressed:(id)sender;

@end
