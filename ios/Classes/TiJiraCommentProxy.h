/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "JMCComment.h"

@interface TiJiraCommentProxy : TiProxy {
    NSString*_requestId;
    NSString* _author;
    NSNumber* _systemUser;
    NSString* _body;
    NSDate* _date;
}

@property (nonatomic, retain) NSString* requestId;
@property (nonatomic, retain) NSString* author;
@property (nonatomic, assign) NSNumber* systemUser;
@property (nonatomic, retain) NSString* body;
@property (nonatomic, retain) NSDate* date;

+(TiJiraCommentProxy*)commentWithComment:(JMCComment*)comment;
-(id)initWithComment:(JMCComment*)comment;

@end
