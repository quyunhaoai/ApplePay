//
//  ViewController.m
//  ApplePay
//
//  Created by hao on 16/7/8.
//  Copyright © 2016年 hao. All rights reserved.
//

#import "LLPaySdk.h"
#import "ViewController.h"
static NSString *url = @"http://www.cheguanjia.la/test/index";

static NSString *kAPMerchantID = @"merchant.com.hncgj.appleapp";
@interface ViewController ()<LLPaySdkDelegate>


@property (nonatomic, retain) NSMutableDictionary *orderParam;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *orgind;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)applePay:(id)sender {
    
    NSString *reurl = [NSString stringWithFormat:@"http://www.cheguanjia.la/test/index"];
    NSURL *rerurl = [NSURL URLWithString:reurl];
    NSMutableURLRequest *rerequest = [[NSMutableURLRequest alloc]initWithURL:rerurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *refresh = [NSURLConnection sendSynchronousRequest:rerequest returningResponse:nil error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:refresh options:NSJSONReadingMutableContainers error:nil];
    self.orderParam = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    self.orderParam[@"ap_merchant_id"] = kAPMerchantID;
    
//    self.orderParam[@"money_order"] = @"0.01";
    
    
    [LLAPPaySDK sharedSdk].sdkDelegate = self;
    [[LLAPPaySDK sharedSdk] payWithTraderInfo:self.orderParam
                             inViewController:self];
    
}
#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                //
                //                NSString *payBackAgreeNo = dic[@"agreementno"];
                //_agreeNumField.text = payBackAgreeNo;
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    
//    NSString *showMsg = [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
    NSString *showMsg = msg;
    
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:showMsg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
}

@end
