//
//  GuideVC.m
//  LLLM
//
//  Created by 瑞 on 16/11/18.
//  Copyright © 2016年 clove. All rights reserved.
//

#import "GuideVC.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#define totalCounts 7  //引导页数量

#define EVER_LAUNCHED @"GuideVC_EVER_LAUNCHED32"

@interface GuideVC ()<UIScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *pageScroll;
@property (strong, nonatomic)  UIPageControl *pageControl;

@end

@implementation GuideVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:EVER_LAUNCHED];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self createScrollView];
}

/**
 *  创建显示引导图片ScrollView
 */
-(void)createScrollView{
    
    self.pageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    self.pageScroll.contentSize = CGSizeMake(Main_Screen_Width * totalCounts, Main_Screen_Height);
    self.pageScroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.pageScroll];
    
    /** 添加引导图片 */
    [self AddGuideImg];
    
    CGFloat w = 100;
    CGFloat h = 20;
    self.pageControl = [[UIPageControl alloc]init];
    [self.pageControl setFrame:CGRectMake((Main_Screen_Width-w)/2, Main_Screen_Height-30, w, h)];
    self.pageControl.numberOfPages = totalCounts;  //设置引导页有几个界面
    self.pageControl.currentPage = 0;
    self.pageControl.tintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pageControl];
    
}

/**
 *  添加引导图片
 */
-(void)AddGuideImg{
    for (int i=0; i<totalCounts; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*Main_Screen_Width, 0, Main_Screen_Width, Main_Screen_Height)];
        NSString* imageNameStr =[NSString stringWithFormat:@"Guide%i.jpg",i+1];//设置引导页图片
        imageView.image = [UIImage imageNamed:imageNameStr];
        
        if (i == totalCounts-1) {
            /** 最后一张图片添加按钮 */
            [imageView setUserInteractionEnabled:YES];
            UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* startBtnImg = [UIImage imageNamed:@"btn"];
            [start setImage:startBtnImg forState:UIControlStateNormal];
            
            [start setFrame:CGRectMake(20,Main_Screen_Height-100,Main_Screen_Width - 20*2,60)];
            start.bottom = Main_Screen_Height-60;
            //            start.layer.borderWidth = 5;
            //            start.layer.borderColor = [UIColor whiteColor].CGColor;
            //            [start setTitle:@"朕已阅" forState:UIControlStateNormal];
            
            [start addTarget:self action:@selector(gotoMainView) forControlEvents:
             UIControlEventTouchUpInside];
            [imageView addSubview:start];
            
        }
        [self.pageScroll addSubview:imageView];
    }
    
}

/** 跳转到首页(登录页) */
-(void)gotoMainView{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
#pragma mark
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

+(BOOL)everLaunched
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:EVER_LAUNCHED];
}

@end
