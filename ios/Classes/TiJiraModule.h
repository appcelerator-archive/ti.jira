/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "TiJiraIssueProxy.h"
#import "TiJiraIssueDelegate.h"
#import "TiJiraReplyDelegate.h"
#import "TiFilesystemFileProxy.h"
#import "JMC.h"
#import "JMCIssueStore.h"
#import "JMCRequestQueue.h"
#import "JMCPing.h"
#import "NSObject+SBJSON.h"
#import "Mimetypes.h"


@interface TiJiraModule : TiModule
{
    JMCIssueTransport *_issueTransport;
    JMCReplyTransport *_replyTransport;
    JMCPing *_pinger;
}

@end
