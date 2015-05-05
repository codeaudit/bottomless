# bottomless
LSTM-based chatbot

# Usage
You need a computational server to run the code in `bot_chat_server`, 
and another server (normally on heroku) for the bot itself.

# Configuration

On the computational server, you need to install (at least) Theano and GroundHog.

Then clone the code and run:

```
cd bot_chat_server/model
./download_models.sh
cd ..
./run.sh &
```

By default it will listen on port 5000. You need to make sure this port is opened.

(The model files are being uploaded, I will update the script when they are available)


Back to local machine, in the `slack_bottom/scripts/example.coffee` folder, you will find the following 2 lines:

```
  POST_MESSAGE_URL = 'https://slack.com/api/chat.postMessage?token=<YOUR_SLACK_TOKEN>&channel=<YOUR_DEBUG_CHANNEL>&username=<YOUR_SLACK_USERNAME>&as_user=true&pretty=1&&text='
  SERVER_ADDRESS = "[COMPUTATIONAL_SERVER_ADDRESS]:5000"
```

Change the variables to match your configuration.

Then you can deploy it normally, as instructed in hubot documentation. 