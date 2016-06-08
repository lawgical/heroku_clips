# heroku_clips class
Ruby class for moving all the clips from an application to a new DB target

## Steps to follow

### I Retrieving the cookies and CSFR Token
Go to the [Clips Index Page](https://dataclips.heroku.com/clips) and use the inspect tool on your browser. For example in Chrome:
  * Do the request again for the index page
  * Go to Network tab and find the `clips.json` request
  * Right-click Copy as cURL
  * Paste the content and then copy the cookies (after `'Cookie:`) and the `X-CSRF-Token` value.

### II Retrieve the Target
The easy way is doing a move by hand in the page and with the inspect tool analyze the response made:
  * Go to Network tab and find the `move` request
  * Right-click Copy as cURL
  * Paste the content and then copy the target (`heroku_resource_id`) that will be at the end. Will be like this: `{"heroku_resource_id":"resource123456@heroku.com"}`

### III Use the Move Method

1. Copy the class if you wanna do it in terminal
2. Call: `HerokuClips.move(name_of_app_in_heroku, target, cookies, csrf_token)`

#### Example of output:
If you receive a different code than 200 in the output `Response getting clips:`,  the process wont't do anything, please check your cookies. But if you get 200, this situations could happen:

#### Moving OK
```
Response getting clips: 200
DataClip Name-Of-Data-Clip moved to resource resource13790699@heroku.com
```

#### Moving FAIL
If something goes bad with the move, the process will stop:

```
Response getting clips: 200
Error moving Name-Of-Data-Clip, response code: 400-Bad Request
Please confirm that you have fresh cookies and csfr token
Stopping...
```
