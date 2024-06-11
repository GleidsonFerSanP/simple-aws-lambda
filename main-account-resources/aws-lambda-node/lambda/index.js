const AWS = require("aws-sdk");
const sqs = new AWS.SQS();

exports.handler = async (event) => {
  const queueUrl =
    "https://sqs.us-east-1.amazonaws.com/992382412051/my-first-sqs-queue"; // Replace with your SQS queue URL

  const params = {
    QueueUrl: queueUrl,
    MaxNumberOfMessages: 10, // Adjust the number of messages to retrieve
    WaitTimeSeconds: 20, // Long polling
  };

  try {
    const data = await sqs.receiveMessage(params).promise();
    if (data.Messages) {
      for (const message of data.Messages) {
        console.log("Message received:", message);
        // Process the message here

        // After processing, delete the message from the queue
        const deleteParams = {
          QueueUrl: queueUrl,
          ReceiptHandle: message.ReceiptHandle,
        };
        await sqs.deleteMessage(deleteParams).promise();
        console.log("Message deleted:", message.MessageId);
      }
    } else {
      console.log("No messages to process");
    }
    return {
      statusCode: 200,
      body: JSON.stringify("Messages processed successfully!"),
    };
  } catch (err) {
    console.error("Error receiving or deleting messages:", err);
    return {
      statusCode: 500,
      body: JSON.stringify("Failed to process messages"),
    };
  }
};
