# ALOR

### Why Alor?

This started as "Accessibility Review Dashboard", or ARD, which is the [airport code for Alor Island Airport](https://en.wikipedia.org/wiki/Alor_Island). 

This project does not currently include the framework for a dashboard interface but could be added in the future.

## Installation & Setup

### Clone the repository

```
git clone https://github.com/sul-dlss-labs/alor.git
```

### Setup your local credentials

#### Create a local settings file for your auth key

Create a `settings.local.yml` file in the `config` path and add the following content:

```
youtube:
  api_key: '[YOUR API KEY]'
```

You can acquire an API key by visiting [Google API Credentials](https://console.cloud.google.com/apis/credentials)

Optionally you can add a default channel ID to your local config under `youtube` in `settings.local.yml` add:

```
channel_id: 'CHANNEL_ID'
```

Note: If a default channel ID is not set, you will need to pass the ID to the rake task.

### Run the caption report using docker

Note: If this is your first time running the report task, docker will first build the image. This should only take a few moments, and is only required on the first run or when changes have occured in the application.

#### Using the default channel ID
```
docker compose run caption_report
```
#### When setting a channel ID
```
docker compose run -e CHANNEL_ID=[INSERT CHANNEL ID] caption_report
```


### Run the caption report through rake

With a default channel id set:

```
bundle exec rake youtube:caption_report
```

Without a default channel id set:

```
bundle exec rake youtube:caption_report["CHANNEL_ID"]
```

### Output

The exported CSV file will be available in `storage/reports/<CHANNEL_ID>-<DATETIME>.csv`

### Cached Data

Cached channel, video, and caption data is stored in `storage/cache/[key]`

By default, the data will be cached mainted for 30 days, but can be set locally by setting:

```
cache:
  expiry_days: 30
```

In your `settings.local.yml` file.
