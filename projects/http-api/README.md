# HTTP API

This project creates an HTTP API via AWS API Gateway. When you run `yarn buildApiGatewayWithoutApproval` or `yarn buildApiGateway` it will build all of the necessary resources within AWS and you'll see the AWS API Gateway invoke url in the console when it finishes.

If you'd like, you can copy the api id from that url and set your `@apiId` and `@region` within [gateway.http](./resources/gateway.http) to hit the endpoints created within the project

To tear everything down you can run `yarn destroyApiGatewayWithoutApproval` or `yarn destroyApiGateway`
