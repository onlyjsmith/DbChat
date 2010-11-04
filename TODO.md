#Background

## Aim
Enable Dropbox users to chat about a folder/file with other people who have access to that folder.

## Functions
Add, with a click, a link to any folder on their Dropbox. 
The link contains a unique URL, so that only people accessing that folder can see the page linked to.
That page can be relatively static - just needs to receive simple updates of text. These updates are added in the page.

## Technique
Use Dropbox API.
Use a Rails chat or text editing page - could be modelled on P2.
Login to dropboxchat.com with your Dropbox username/password.

### To initiate the page/link
Simplest version: navigate to the folder using the browser, and click 'initiate'.
(More complex would be to integrate into filesystem - best stick with simple version for now!)
Simple version creates a shortcut to a specific, randomly generated URL. 
(If the filename were obvious enough, the little on-screen status update could be useful! 'Chat updated' or something)

### To use the page
Click on the link (either from folder or bookmark), and go to web page.
Optionally login (either manually or by cookie/stored password)
Enter your comment and leave.

## Nuts and bolts

### Dropbox API
- Need to login, set up a session
- Need to read directory list
- Need to select a directory
- Need to create the URL shortcut in the directory

### Chat server
- Link to Dropbox account
- List all recent changes in a sidebar
- List recent chats on this document in reverse chronological order (with username, date/time)
- Box at top of page to add your most recent thought/comment

## Issues (before we even get started!)
What happens if you've got more than one DropboxChat.html that you're editing? Need to think about the naming strategy for the shortcut folder. Can also have a landing page on the website (or preferably a sidebar) that lists all the recent edits.

## Expanding it (before we even get started!)
Email updates to users, as they want.

# Getting started

## Version 1
Login to dropbox and list all folders
Setup a model for "folders" which includes the URL, folder location, and then all previous comments. 
Can even use the simplest blog application that scaffolding brings together.