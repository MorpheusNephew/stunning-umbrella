# Hello World Lambda

This project creates an AWS Lambda function that's served up by a REST API via AWS API Gateway. When you run `yarn buildApiGatewayWithoutApproval` or `yarn buildApiGateway` it will build all of the necessary resources within AWS and you'll see the AWS API Gateway invoke url in the console when it finishes.

Simply go to that invoke url to be able to see hello world in the response.

To tear everything down you can run `yarn destroyApiGatewayWithoutApproval` or `yarn destroyApiGateway`
