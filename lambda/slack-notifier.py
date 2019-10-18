/**
 * Copyright (C) 2018-2019 Expedia Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

# This function was originally derived from the AWS blueprint named cloudwatch-alarm-to-slack-python.
# Please see here for details: https://aws.amazon.com/blogs/aws/new-slack-integration-blueprints-for-aws-lambda/.
import boto3
import json
import logging
import os

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_CHANNEL = os.environ["slackChannel"]
HOOK_URL = os.environ["slackWebhookUrl"]
ACCOUNT = os.environ["account"]

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = json.loads(event["Records"][0]["Sns"]["Message"])
    logger.info("Message: " + str(message))

    alarm_name = message["AlarmName"]
    new_state = message["NewStateValue"]
    reason = message["NewStateReason"]

    slack_message = {
        "channel": SLACK_CHANNEL,
        "text": "%s in %s has transitioned to %s" % (alarm_name, ACCOUNT, new_state),
        "attachments": [
            {
                "color": "#e04343",
                "text": "%s" % (reason)
            }
        ]
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode("utf-8"))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message["channel"])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
