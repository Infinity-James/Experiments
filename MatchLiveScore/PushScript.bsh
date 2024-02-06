export TEAM_ID=ZFDEX86BMA
export TOKEN_KEY_FILE_NAME=/Users/james/Developer/Other/Experimentation/push-key.p8
export AUTH_KEY_ID=K299NNPL9A
export DEVICE_TOKEN=801596113b60e883a18ab5a1dcb8697d6ceffcb46fb136c37bf4e26b831b480be95aba5e34b67656a52d7c4511653ad1cec257360194b3ec7c1dadde34e6d47c3185f254697d1db215d8ab5fed100509
export APNS_HOST_NAME=api.sandbox.push.apple.com

export JWT_ISSUE_TIME=$(date +%s)

export JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)

export JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)

export JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"

export JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)

export AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

curl \
-H "apns-topic: co.andbeyond.experiments.push-type.liveactivity" \
-H "apns-push-type: liveactivity" \
-H "apns-priority: 10" \
-H "authorization: bearer $AUTHENTICATION_TOKEN" \
-d '{
    "aps": {
        "alert" : {
            "title" : "Spurs are at it!",
            "subtitle" : "Deki slots one in!",
            "body" : "Goal scored!"
        },
        "timestamp": '$(date +%s)',
        "event": "update",
        "content-state": {
            "homeTeamScore": 5,
            "awayTeamScore": 0,
            "lastEvent": "Deki is a hero!"
        }
    }
}' \
--http2 https://api.sandbox.push.apple.com/3/device/$DEVICE_TOKEN
