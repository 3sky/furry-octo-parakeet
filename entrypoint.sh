#!/bin/sh -l

# Define variables
AUTH_FILE=$1
ACTION_TYPE=$2
NAME=$3
REGION=$4
PORT=$5
IMAGE=$6
ALLOW=$7
PROJECT_ID=$8

# Encode GH secret
echo "$AUTH_FILE" | base64 -d > /tmp/auth.json
chmod 777 /tmp/auth.json

# Get project_id and EMAIL
PROJECT_ID=$(jq -r .project_id /tmp/auth.json)
EMAIL=$(jq -r .client_email /tmp/auth.json)

# Activate account
if gcloud auth activate-service-account "$EMAIL" --key-file=/tmp/auth.json ; then
    echo "Authentication successful"
else
    echo "Authentication faild"
    exit 1;
fi

# Set project
if gcloud config set project "$PROJECT_ID" ; then
    echo "Setting project successful"
else
    echo "Setting project faild"
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
    --region "$REGION" \
    --quiet 
fi
