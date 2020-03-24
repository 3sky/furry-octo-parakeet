#!/bin/sh -l

# Define variables
EMAIL=$1
AUTH_FILE=$2
ACTION_TYPE=$3
NAME=$4
REGION=$5
PORT=$6
IMAGE=$7
ALLOW=$8

echo "$AUTH_FILE" | base64 --decode > /tmp/auth.json
chmod 777 /tmp/auth.json

# Activate account
if gcloud auth activate-service-account "$EMAIL" --key-file=/tmp/auth.json ; then
    echo "Authentication successful"
else
    echo "Authentication faild"
    exit 1;
fi

if [ "$ACTION_TYPE" = "run" ] || [ "$ACTION_TYPE" = "update" ] || [ "$ACTION_TYPE" = "delete" ]; then
    echo "Choose $ACTION_TYPE as action type"
else
    echo "Wrong action type, Possible solution run|update|delete"
    exit 1;
fi


if [ "$ACTION_TYPE" = "run" ]; then
    if $ALLOW; then 
        gcloud run deploy "$NAME" \
        --platform managed \
        --allow-unauthenticated \
        --region "$REGION" \
        --port "$PORT" \
        --image "$IMAGE"
    else 
        gcloud run deploy "$NAME" \
        --platform managed \
        --region "$REGION" \
        --port "$PORT" \
        --image "$IMAGE"
    fi
elif [ "$ACTION_TYPE" = "update" ]; then
    gcloud run deploy "$NAME" \
    --platform managed \
    --region "$REGION" \
    --image "$IMAGE"
elif [ "$ACTION_TYPE" = "delete" ]; then
    gcloud run services delete "$NAME" \
    --platform managed \
    --region "$REGION"  
fi