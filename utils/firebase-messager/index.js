const axios = require('axios');
const {google} = require('googleapis')
const opts = require('optimist').argv
const jsonCreditals = require(opts.file)

const data = JSON.stringify({
    "message": {
        "topic": "group."+opts.group,
        "data": {
            "type": "warning",
            "alert": "Пари змінились"
        },
        "notification": {
            "title": "Пари змінились!",
            "body": "Перейдіть щоб подивитись зміни"
        },
        "android": {
            "priority": "high"
        },
        "apns": {
            "payload": {
                "aps": {
                    "contentAvailable": true
                }
            },
            "headers": {
                "apns-push-type": "background",
                "apns-priority": "5"
            }
        }
    }
});

(async() => {
    const jwtClient = new google.auth.JWT(
        jsonCreditals.client_email,
        null,
        jsonCreditals.private_key,
        "https://www.googleapis.com/auth/cloud-platform"
    );

    const token = await jwtClient.authorize();
    
    const response = await axios({method: 'post',
            url: `https://fcm.googleapis.com/v1/projects/${jsonCreditals.project_id}/messages:send`,
            headers: {
                'Authorization': 'Bearer '+ token.access_token,
                'Content-Type': 'application/json'
            },
            data: data});
    return response.data;
})().then(console.log).catch(console.log)
