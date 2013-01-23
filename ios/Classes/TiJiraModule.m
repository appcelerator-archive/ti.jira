/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiJiraModule.h"

@implementation TiJiraModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"6e69fb14-df2b-4e78-8708-e8c0c3df770d";
}

-(NSString*)moduleId
{
	return @"ti.jira";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
    [self rememberSelf];
}

-(void)shutdown:(id)sender
{
	[super shutdown:sender];
    [self forgetSelf];
}

#pragma mark Utility Methods



-(JMCAttachmentItem*)processAttachment:(id)arg
{
    NSData* data;
    NSString* name;
    NSString* contentType = @"text/plain";
    JMCAttachmentType type = JMCAttachmentTypeCustom;
	
	if ([arg isKindOfClass:[TiBlob class]])
	{
        name = @"unknown";
		TiBlob* blob = (TiBlob*)arg;
        data = [blob data];
        if (blob.type == TiBlobTypeImage) {
            type = JMCAttachmentTypeImage;
        }
	}
	else if ([arg isKindOfClass:[TiFile class]])
	{
        TiFile *file = (TiFile*)arg;
        NSString *path = [file path];
        name = [path lastPathComponent];
        data = [NSData dataWithContentsOfFile:path];
        contentType = [Mimetypes mimeTypeForExtension:path];
	}
	else if ([arg isKindOfClass:[NSString class]]) {
		NSURL* url = [TiUtils toURL:arg proxy:self];
        name = [arg lastPathComponent];
        data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                      returningResponse:nil
                                                  error:nil];
        contentType = [Mimetypes mimeTypeForExtension:name];
    }
    else {
        [self throwException:@"Unsupported attachment provided!" subreason:@"Please provide a URL, TiFile, or Blob!" location:CODELOCATION];
    }
    
    if ([contentType hasPrefix:@"image/"]) {
        type = JMCAttachmentTypeImage;
    }
    
    NSLog(@"Attachment provided with %@, %@", name, [name stringByDeletingPathExtension]);
    NSLog(@"Content Type: %@", contentType);
    NSLog(@"Type: %d", type);
    NSLog(@"Data: %@", data);
    
    JMCAttachmentItem* item = [[JMCAttachmentItem alloc] initWithName:[name stringByDeletingPathExtension]
                                                                 data:data
                                                                 type:type
                                                          contentType:contentType
                                                       filenameFormat:name];
    return item;
}

#pragma mark Public API

-(void)initialize:(id)args
{
    ENSURE_UI_THREAD(initialize, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    [[JMC instance] configureWithOptions:
     [JMCOptions optionsWithUrl:[args valueForKey:@"url"]
                        project:[args valueForKey:@"projectKey"]
                         apiKey:[args valueForKey:@"apiKey"]
                         photos:[TiUtils boolValue:[args valueForKey:@"allowPhotos"] def:YES]
                          voice:[TiUtils boolValue:[args valueForKey:@"allowVoice"] def:YES]
                       location:[TiUtils boolValue:[args valueForKey:@"allowLocation"] def:YES]
                 crashreporting:[TiUtils boolValue:[args valueForKey:@"allowCrashReporting"] def:YES]
                   customFields:[args valueForKey:@"customFields"]]];
    
    _pinger = [[[JMCPing alloc] init] retain];
    _issueTransport = [[JMCIssueTransport alloc] init];
    _issueTransport.delegate = [[TiJiraIssueDelegate alloc] initWithParentProxy:self];
    [JMCRequestQueue sharedInstance].issueTransport = _issueTransport;
    
    _replyTransport = [[JMCReplyTransport alloc] init];
    _replyTransport.delegate = [[TiJiraReplyDelegate alloc] initWithParentProxy:self];
    [JMCRequestQueue sharedInstance].replyTransport = _replyTransport;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedComments:) name:kJMCReceivedCommentsNotification object:nil];
}

-(void)ping:(id)arguments
{
    [_pinger sendPing];
}

-(void)receivedComments:(id)args
{
    [self fireEvent:@"receivedComments"];
}

-(void)submitIssue:(id)arguments
{
    id props = [arguments objectAtIndex:0]; 
    NSString* description = [props valueForKey:@"description"];
    NSArray* rawAttachments = [props valueForKey:@"attachments"];
    
    if ([description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0 && rawAttachments.count <= 0) {
        // No data entered, just return.
        return;
    }
    
    // parse the raw attachments in to JMCAttachmentItems
    NSMutableArray* attachments = [NSMutableArray arrayWithCapacity:[rawAttachments count]];
    for (id attachment in rawAttachments) {
        [attachments addObject:[self processAttachment:attachment]];
    }
    
    // add all custom fields as one attachment item
    NSMutableDictionary* customFields = [[JMC instance] getCustomFields];
    NSData* customFieldsJSON = [[customFields JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
    
    JMCAttachmentItem* customFieldsItem = [[JMCAttachmentItem alloc] initWithName:@"customfields"
                                                                             data:customFieldsJSON
                                                                             type:JMCAttachmentTypeCustom
                                                                      contentType:@"application/json"
                                                                   filenameFormat:@"customfields.json"];
    [attachments addObject:customFieldsItem];
    [customFieldsItem release];
    
    // use the first 80 chars of the description as the issue summary
    u_int toIndex = [description length] > 80 ? 80 : [description length];
    NSString* truncationMarker = [description length] > 80 ? @"..." : @"";
    [_issueTransport send:[[description substringToIndex:toIndex] stringByAppendingString:truncationMarker]
              description:description
              attachments:attachments];
}

-(void)commentOnIssue:(id)arguments
{
    id props = [arguments objectAtIndex:0]; 
    NSString* description = [props valueForKey:@"description"];
    NSArray* rawAttachments = [props valueForKey:@"attachments"];
    
    if ([description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0 && rawAttachments.count <= 0) {
        // No data entered, just return.
        return;
    }
    
    // parse the raw attachments in to JMCAttachmentItems
    NSMutableArray* attachments = [NSMutableArray arrayWithCapacity:[rawAttachments count]];
    for (id attachment in rawAttachments) {
        [attachments addObject:[self processAttachment:attachment]];
    }
    
    NSString* issueKey = [props valueForKey:@"key"];
    JMCIssue* issue = [[JMCIssue alloc] initWithDictionary:[NSDictionary dictionaryWithObject:issueKey forKey:@"key"]];
    [_replyTransport sendReply:issue
                   description:description
                   attachments:attachments];
    [issue release];
}

-(id)retrieveIssues:(id)args
{
    JMCIssueStore* store = [JMCIssueStore instance];
    int count = [store count];
    NSMutableArray* retVal = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [retVal addObject:[TiJiraIssueProxy issueWithIssue:[store newIssueAtIndex:i]]];
    }
    return retVal;
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}

-(void)dealloc
{
    [_issueTransport.delegate release];
    [_issueTransport release];
    
    [_replyTransport.delegate release];
    [_replyTransport release];
    
    [_pinger release];
    
    [super dealloc];
}

@end
