# Overview
Terraform deployment scripts for [Beekeeper](https://github.com/ExpediaGroup/beekeeper).

# Modules
* [Main](https://github.com/ExpediaGroup/beekeeper/tree/master/main) - main AWS components required to run Beekepeer e.g. ECS, SQS, IAM etc.
* [Lambda](https://github.com/ExpediaGroup/beekeeper/tree/master/lambda) - Lambda which monitors Beekeeper's dead letter queue and sends notifications to Slack. This module is optional and not required to run Beekeeper.

# Legal
This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2019 Expedia, Inc.
