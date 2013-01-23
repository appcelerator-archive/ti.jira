# Ti.JIRA.Issue

## Description

Represents an issue.

## Properties

### Date dateCreated
### Date dateUpdated
### String requestId
### String key
### String status
### String summary
### String description
### [Ti.JIRA.Comment][][] comments
### boolean hasUpdates

## Methods

### void markAsRead()
Marks this issue's updates as having been read. This will change "hasUpdates" to false.

[Ti.JIRA.Comment]: comment.html