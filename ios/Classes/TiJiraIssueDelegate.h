/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "JMCTransport.h"
#import "JMCIssueStore.h"
#import "TiProxy.h"

@interface TiJiraIssueDelegate : NSObject<JMCTransportDelegate>
{
    TiProxy* parentProxy;
}

-(id)initWithParentProxy:(TiProxy*)proxy;

@end
