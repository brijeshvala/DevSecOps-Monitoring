#!/bin/bash
STATUS=$1       # SUCCESS or FAILURE
STAGE=$2        # e.g., "Gitleaks", "Trivy Container Scan"
DETAILS=$3      # Extra details or logs
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"
TEAMS_WEBHOOK_URL="https://yourdomain.webhook.office.com/webhookb2/..."

if [ "$STATUS" == "FAILURE" ]; then
  COLOR="#FF0000"
  MESSAGE="🚨 *DevSecOps Pipeline Alert* - Stage Failed: *$STAGE*\n*Details:* $DETAILS"
else
  COLOR="#00FF00"
  MESSAGE="✅ *DevSecOps Pipeline Success* - Stage Passed: *$STAGE*"
fi

# Send to Slack
curl -s -X POST -H 'Content-type: application/json' \
  --data "{\"attachments\":[{\"color\":\"$COLOR\",\"text\":\"$MESSAGE\"}]}" \
  $SLACK_WEBHOOK_URL

# Send to MS Teams
curl -s -X POST -H 'Content-Type: application/json' \
  --data "{\"text\":\"$MESSAGE\"}" \
  $TEAMS_WEBHOOK_URL