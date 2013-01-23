/**
   Copyright 2011 Atlassian Software

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/
//
//  Created by nick on 7/05/11.
//
//  To change this template use File | Settings | File Templates.
//
#import "JMCMessageBubble.h"

@interface JMCMessageBubble ()
@property (nonatomic, retain) UIImageView *bubble;

@end

@implementation JMCMessageBubble

@synthesize bubble, detailLabel, label;

- (id)initWithReuseIdentifier:(NSString *)cellIdentifierComment detailSize:(CGSize)detailSize {

    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierComment])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // this is a work-around for self.backgroundColor = [UIColor clearColor]; appearing black on iOS < 4.3 .
        UIView *transparentBackground = [[UIView alloc] initWithFrame:CGRectZero];
        transparentBackground.backgroundColor = [UIColor clearColor];
        self.backgroundView = transparentBackground;
        [transparentBackground release];

        bubble = [[UIImageView alloc] initWithFrame:CGRectZero];

        detailLabelHeight = detailSize.height;

        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2;
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.backgroundColor = [UIColor clearColor];

        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, detailSize.width, detailLabelHeight)];
        detailLabel.tag = 3;
        detailLabel.numberOfLines = 1;
        detailLabel.lineBreakMode = UILineBreakModeClip;
        detailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = UITextAlignmentCenter;

        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [message addSubview:detailLabel];
        [message addSubview:bubble];
        [message addSubview:label];
        message.autoresizesSubviews = YES;
        message.tag = 22;
        [self.contentView addSubview:message];
        self.contentView.autoresizesSubviews = YES;

        [message release];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];

    // only when layoutSubviews is called, is the contentFrame setup correctly.
    CGRect contentFrame = self.contentView.frame;
    
    CGRect detailFrame = self.detailLabel.frame;
    detailFrame.size.width = contentFrame.size.width;
    self.detailLabel.frame = detailFrame; // This is only picked up when the cell goes offscreen...
    
    CGRect bubbleFrame = self.bubble.frame;
    CGRect labelFrame = self.label.frame;
    
    if (bubbleFrame.origin.x == 0) { 
        return; // only views that are right justified require relayout.
    }
    // set the correct x coord of the right aligned bubble
    bubbleFrame = CGRectMake(contentFrame.size.width - bubbleFrame.size.width, 
                                   bubbleFrame.origin.y, bubbleFrame.size.width, bubbleFrame.size.height);

    // the same for the label that is in the bubble
    labelFrame.origin.x = bubbleFrame.origin.x + 12.0f;
    self.label.frame = labelFrame;
    self.bubble.frame = bubbleFrame;
}

- (void)setText:(NSString *)string leftAligned:(BOOL)leftAligned withFont:(UIFont *)font size:(CGSize)constSize
{

    CGSize size = [string sizeWithFont:font 
                     constrainedToSize:CGSizeMake(constSize.width * 0.75, constSize.height)
                         lineBreakMode:UILineBreakModeWordWrap];
    
    UIImage * balloon;
    float balloonY = 2.0f + detailLabelHeight;
    float labelY = 8.0f + detailLabelHeight;
    if (leftAligned) {
        float width = size.width + 30.0f;
        float x = self.contentView.frame.size.width - width;
        CGRect frame = CGRectMake(x, balloonY, width, size.height + 12.0f);
        self.bubble.frame = frame;
        self.bubble.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        balloon = [[UIImage imageNamed:@"Balloon_1"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:15.0f];
        self.label.frame = CGRectMake(frame.origin.x + 12.0f, labelY - 2.0f, size.width + 5.0f, size.height);

    } else {
        self.bubble.frame = CGRectMake(0.0f, balloonY, size.width + 28.0f, size.height + 12.0f);
        self.bubble.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        balloon = [[UIImage imageNamed:@"Balloon_2"] stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
        self.label.frame = CGRectMake(20.0f, labelY - 2.0f, size.width + 5, size.height);
    } 
    self.bubble.image = balloon;
    self.label.text = string;

}

- (void)dealloc {
    [bubble release];
    [detailLabel release];
    [label release];
    [super dealloc];
}

@end
