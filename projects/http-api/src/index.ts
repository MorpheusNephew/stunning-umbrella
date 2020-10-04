require("dotenv").config();

import { Context } from "aws-lambda";
import Koa from "koa";
import ServerlessHttp from "serverless-http";

import { router } from "./routers";

const app = new Koa();

app.use(async (ctx, next) => {
  if (ctx.path === "/favicon.ico") {
    console.log("returning due to favicon.ico request");
    return;
  }

  await next();
});

app.use(router.routes());

const handler = ServerlessHttp(app);

exports.handler = async (event: any, context: Context) => {
  return await handler(event, context);
};

if (process.env.NODE_ENV !== "production") {
  app.listen(process.env.NODE_PORT);
}
