import { Context } from "aws-lambda";
import Koa from "koa";
import Router from "@koa/router";
import ServerlessHttp from "serverless-http";

const app = new Koa();

const router = new Router();

router.get("/", async (ctx) => {
  ctx.body = "This is a GET";
});

router.post("/", async (ctx) => {
  ctx.body = "This is a POST";
});

app.use(router.routes());

const handler = ServerlessHttp(app);

exports.handler = async (event: any, context: Context) => {
  return await handler(event, context);
};
