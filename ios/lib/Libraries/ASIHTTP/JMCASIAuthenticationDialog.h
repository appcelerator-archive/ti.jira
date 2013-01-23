//
//  JMCASIAuthenticationDialog.h
//  Part of JMCASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 21/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JMCASIHTTPRequest;

typedef enum _ASIAuthenticationType {
	JMCASIStandardAuthenticationType = 0,
    JMCASIProxyAuthenticationType = 1
} JMCASIAuthenticationType;

@interface JMCASIAutorotatingViewController : UIViewController
@end

@interface JMCASIAuthenticationDialog : JMCASIAutorotatingViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	JMCASIHTTPRequest *request;
	JMCASIAuthenticationType type;
	UITableView *tableView;
	UIViewController *presentingController;
	BOOL didEnableRotationNotifications;
}
+ (void)presentAuthenticationDialogForRequest:(JMCASIHTTPRequest *)request;
+ (void)dismiss;

@property (retain) JMCASIHTTPRequest *request;
@property (assign) JMCASIAuthenticationType type;
@property (assign) BOOL didEnableRotationNotifications;
@property (retain, nonatomic) UIViewController *presentingController;
@end
