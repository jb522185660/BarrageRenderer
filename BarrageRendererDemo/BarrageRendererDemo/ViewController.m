//
//  BarrageTestController.m
//  demo_app_main
//
//  Created by UnAsh on 15/7/10.
//  Copyright (c) 2015年 UnAsh. All rights reserved.
//

#import "ViewController.h"
#import "BarrageHeader.h"
#import "NSSafeObject.h"
#import "BarrageSpiritUtility.h"
#import "UIImage+Barrage.h"

@interface ViewController()
{
    BarrageRenderer * _renderer;
    NSTimer * _timer;
    NSInteger _index;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _index = 0;
    _renderer = [[BarrageRenderer alloc]init];
    [_renderer setSpeed:1.0f];
    [self.view addSubview:_renderer.view];
    [self.view sendSubviewToBack:_renderer.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    [self performSelector:@selector(viewChanged) withObject:nil afterDelay:10.0f];
}

- (void)viewChanged
{
    [_renderer setSpeed:2.0f];
}

- (void)dealloc
{
    [_renderer stop];
}

#pragma mark - Action
- (IBAction)start:(id)sender
{
    [_renderer start];
}
- (IBAction)stop:(id)sender
{
    [_renderer stop];
}
- (IBAction)pause:(id)sender
{
    [_renderer pause];
}
- (IBAction)resume:(id)sender
{
    [_renderer start];
}
- (IBAction)send:(id)sender
{
    [self manualSendBarrage];
}
- (IBAction)faster:(id)sender
{
    CGFloat speed = _renderer.speed + 0.5;
    if (speed >= 10) {
        speed = 10.0f;
    }
    _renderer.speed = speed;
}
- (IBAction)slower:(id)sender
{
    CGFloat speed = _renderer.speed - 0.5;
    if (speed <= 0.5f) {
        speed = 0.5;
    }
    _renderer.speed = speed;
}

- (void)autoSendBarrage
{
    [_renderer receive:[self floatTextSpiritDescriptorWithDirection:2]];
    [_renderer receive:[self walkTextSpiritDescriptorWithDirection:1]];
//    [_renderer receive:[self floatImageSpiritDescriptorWithDirection:1]];
    [_renderer receive:[self walkImageSpiritDescriptorWithDirection:2]];
}

- (void)manualSendBarrage
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageWalkTextSpirit";
    [descriptor.params setObject:[NSString stringWithFormat:@"过场弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(random_between(10,30)) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor greenColor] forKey:@"borderColor"];
    [descriptor.params setObject:[UIColor yellowColor] forKey:@"backgroundColor"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"direction"];
    [_renderer receive:descriptor];
}

/// 生成精灵描述
- (BarrageDescriptor *)walkTextSpiritDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageWalkTextSpirit";
    [descriptor.params setObject:[NSString stringWithFormat:@"过场弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(random_between(10,30)) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor blueColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述
- (BarrageDescriptor *)floatTextSpiritDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageFloatTextSpirit";
    [descriptor.params setObject:[NSString stringWithFormat:@"悬浮弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(random_between(10,15)) forKey:@"fontSize"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:[UIColor purpleColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述
- (BarrageDescriptor *)walkImageSpiritDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageWalkImageSpirit";
    [descriptor.params setObject:[[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(40, random_between(10,30))] forKey:@"image"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述
- (BarrageDescriptor *)floatImageSpiritDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageFloatImageSpirit";
    [descriptor.params setObject:[[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(40, random_between(10,30))] forKey:@"image"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

@end
