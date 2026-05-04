function resp(statusCode, bodyObj) {
  return {
    statusCode,
    headers: { "Access-Control-Allow-Origin": "*" },
    body: JSON.stringify(bodyObj),
  };
}

const ALLOWED_ACTIONS = [
  "new",
  "orders",
  "get",
  "shipping",
  "billing",
  "cancel",
  "update",
  "get-receipt",
];

exports.handler = (event, context, callback) => {
  let body;
  try {
    body = typeof event.body === "string" ? JSON.parse(event.body) : event.body;
  } catch (err) {
    return callback(
      null,
      resp(400, { status: "err", msg: "invalid request body" })
    );
  }

  if (!body || typeof body !== "object") {
    return callback(
      null,
      resp(400, { status: "err", msg: "invalid request body" })
    );
  }

  if (!ALLOWED_ACTIONS.includes(body.action)) {
    return callback(
      null,
      resp(400, { status: "err", msg: "unknown action" })
    );
  }
};
