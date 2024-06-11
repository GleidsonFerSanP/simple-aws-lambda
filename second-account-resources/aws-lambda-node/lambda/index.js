const AWS = require("aws-sdk");
const sns = new AWS.SNS();

exports.handler = async (event) => {
  const params = {
    Message: "Hello from Lambda!", // Message to be sent
    TopicArn: "arn:aws:sns:us-east-1:992382412051:my-first-sns-topic", // Replace with your SNS topic ARN
  };

  try {
    const data = await sns.publish(params).promise();
    console.log(`Message sent to the topic ${params.TopicArn}`);
    console.log("MessageID is " + data.MessageId);
    return {
      statusCode: 200,
      body: JSON.stringify("Message sent successfully!"),
    };
  } catch (err) {
    console.error(err, err.stack);
    return {
      statusCode: 500,
      body: JSON.stringify("Failed to send message"),
    };
  }
};
