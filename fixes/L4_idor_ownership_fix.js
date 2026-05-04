function resp(statusCode, bodyObj) {
  return {
    statusCode,
    headers: { "Access-Control-Allow-Origin": "*" },
    body: JSON.stringify(bodyObj),
  };
}

async function handleGetOrder(body, user, isAdmin, callback) {
  const orderId = body["order-id"];

  if (!orderId || typeof orderId !== "string") {
    return callback(
      null,
      resp(400, { status: "err", msg: "missing or invalid order-id" })
    );
  }

  const result = await dynamoDB
    .get({
      TableName: process.env.orders_table,
      Key: { "order-id": orderId },
    })
    .promise();

  if (!result.Item) {
    return callback(
      null,
      resp(404, { status: "err", msg: "order not found" })
    );
  }

  if (result.Item.userId !== user && !isAdmin) {
    return callback(
      null,
      resp(403, { status: "err", msg: "access denied" })
    );
  }

  return callback(null, resp(200, { status: "ok", order: result.Item }));
}
