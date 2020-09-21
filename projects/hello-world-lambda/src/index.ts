import { Context } from "aws-lambda";
import { helloWorld } from "./hello-world";

exports.handler = async (event: any, context: Context) => {
  console.log(event, context);

  return helloWorld();
};
