//
//  DemoViewController.m
//  MBFrostedGlassStylePopupDemo
//
//  Created by akira on 13-11-27.
//  Copyright (c) 2013年 akira. All rights reserved.
//


#define kDefaultFont16  [UIFont fontWithName:@"Futura-Medium" size:16.0f]
#define kDefaultFont22  [UIFont fontWithName:@"Futura-Medium" size:22.0f]

#import "DemoViewController.h"
#import "MBFrostedGlassStylePopup.h"

@interface DemoViewController (){
    MBFrostedGlassStylePopup *popup;
}
-(void)show;
@end



@implementation DemoViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imgArray = @[@"1",@"2",@"3",@"4"];
    
    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [scView setContentSize:CGSizeMake(320*[imgArray count], 568)];
    scView.pagingEnabled = YES;
    [self.view addSubview:scView];
    
    for (int i=0,j=[imgArray count]; i<j; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imgArray objectAtIndex:i]]];
        [imgView setFrame:CGRectMake(i*320, 0, 320, 568)];
        imgView.contentMode = UIViewContentModeScaleToFill;
        [scView addSubview:imgView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 200, 320, 60)];
    [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.75]];
    [button setTitle:@"Show Popup" forState:UIControlStateNormal];
    button.titleLabel.font = kDefaultFont16;
    [button setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIPageControl *pc =[[UIPageControl alloc] init];
    pc.numberOfPages = [imgArray count];
    
    [pc setFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 20)];
    [self.view addSubview:pc];
    
    
    popup = [[MBFrostedGlassStylePopup alloc] init];
    
    UILabel *popupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 320, 20)];
    popupTitle.text = @"Hello Frosted";
    popupTitle.textColor =[UIColor colorWithRed:28.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1];
    popupTitle.textAlignment = UITextAlignmentCenter;
    popupTitle.font = kDefaultFont22;
    [popup.contentView addSubview:popupTitle];
    
	// Do any additional setup after loading the view.
    
    
}

-(void)show{
    [popup showInViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
