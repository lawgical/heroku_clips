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
If everything goes OK:

```
Response getting clips: 200
Response after moving clip: 200
DataClip ATF: Affidavit Usage in MT moved to resource resource13790699@heroku.com
```
