#!/bin/bash
# Route 53 editor

. "${BASH_SOURCE%/*}/foovi.sh"

DOMAIN="$1"
PATTERN="$2"

if [[ -z $DOMAIN || -z $PATTERN ]]; then
    echo "Usage: $0 DOMAIN PATTERN"
    echo
    echo "Edit route 53 records in a text editor"
    echo
    echo "DOMAIN -- the domain you want to edit"
    echo "PATTERN -- a search term for records to edit"
    exit 1
fi

get() {
    aws route53 list-resource-record-sets --hosted-zone-id "$ZONEID" | \
        jq -r '[
            .ResourceRecordSets[] |
                select(.Name | contains("'"$PATTERN"'")) |
            {Action: "UPSERT", ResourceRecordSet: .}
        ] |
        {Changes: .}
        ' > "$TEMPFILE"
}

post() {
    aws route53 change-resource-record-sets \
        --hosted-zone-id "$ZONEID" \
        --change-batch "file://$TEMPFILE" \
        --output text
}

ZONEID=$(aws route53 list-hosted-zones |
    jq -r '.HostedZones[] | select(.Name == "'"$DOMAIN"'.") | .Id')

if [[ -z $ZONEID ]]; then
    echo "Unable to get Zone ID for domain $DOMAIN"
    echo "Exiting..."
    exit 1
fi

foovi
