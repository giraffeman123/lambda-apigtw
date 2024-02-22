const sortUtils = require("./utils/sortUtils");

exports.handler = async function (event, context) {
    // console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2));
    // console.log("EVENT\n" + JSON.stringify(event, null, 2));    
    var apiGtwBody = JSON.parse(event.body);
    var nums = apiGtwBody.nums;    
    var sortedArray = sortUtils.mergeSort(nums);        

    const response = { "nums" : sortedArray };    
    return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify(response)
      };    
}