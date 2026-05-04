const AWS = require("aws-sdk");
const s3 = new AWS.S3();
const dynamoDB = new AWS.DynamoDB.DocumentClient();

function resp(statusCode, bodyObj) {
  return {
    statusCode,
    headers: { "Access-Control-Allow-Origin": "*" },
    body: JSON.stringify(bodyObj),
  };
}

exports.handler = async (event) => {
  const { orderId, authenticatedUserId, isAdmin } = event;

  const orderLookup = await dynamoDB
    .get({
      TableName: process.env.orders_table,
      Key: { "order-id": orderId },
    })
    .promise();

  if (!orderLookup.Item) {
    return resp(404, { status: "err", msg: "order not found" });
  }

  const ownerOk = orderLookup.Item.userId === authenticatedUserId;
  if (!ownerOk && !isAdmin) {
    return resp(403, { status: "err", msg: "access denied" });
  }

  const url = s3.getSignedUrl("getObject", {
    Bucket: process.env.receipts_bucket,
    Key: `receipts/${orderId}.pdf`,
    Expires: 60 * 5,
  });

  return resp(200, { status: "ok", url });
};
