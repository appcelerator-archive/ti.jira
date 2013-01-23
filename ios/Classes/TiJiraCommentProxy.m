/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiJiraCommentProxy.h"
#import "TiUtils.h"

@implementation TiJiraCommentProxy

@synthesize requestId = _requestId, author = _author, systemUser = _systemUser, body = _body, date = _date;

+(TiJiraCommentProxy*)commentWithComment:(JMCComment *)comment
{
    return [[[TiJiraCommentProxy alloc] initWithComment:comment] autorelease];
}

-(id)initWithComment:(JMCComment *)comment
{
    if ((self = [super init])) {
        _requestId = [comment.requestId retain];
        _author = [comment.author retain];
        _systemUser = [NUMBOOL(comment.systemUser) retain];
        _body = [comment.body retain];
        _date = [comment.date retain];
    }
    return self;
}

- (void) dealloc
{
    [_requestId release];
    [_author release];
    [_systemUser release];
    [_body release];
    [_date release];
    [super dealloc];
}

@end
