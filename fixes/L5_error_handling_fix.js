function resp(statusCode, bodyObj) {
  return {
    statusCode,
    headers: { "Access-Control-Allow-Origin": "*" },
    body: JSON.stringify(bodyObj),
  };
}

exports.handler = async (event, context) => {
  try {
    return resp(200, { status: "ok" });
  } catch (err) {
    console.error("[UNHANDLED]", {
      message: err.message,
      stack: err.stack,
      requestId: context && context.awsRequestId,
    });

    return resp(500, {
      status: "err",
      msg: "service error",
    });
  }
};
