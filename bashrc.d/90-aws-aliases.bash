# useful functions
watch_elb_health() {
  elb="$1"
  [ -z "$elb" ] && return 1
  while echo -e "\n----- $elb ----" && aws elb describe-instance-health --output text --load-balancer-name "$elb"; do sleep 10 ; done
}

# clear current AWS environment variables set via .bashrc_aws
aws_clear() {
    unset AWS_ACCOUNT_ID AWS_ACCESS_KEY_ID AWS_SECRET_KEY AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION AWS_DEFAULT_OUTPUT
    unset EC2_PRIVATE_KEY EC2_CERT
    export GIT_PS1_PRE='\[\033[01;32m\]\u\[\033[01;34m\]@\h\[\033[00m\] \w'
}

# list all stacks
alias cfn-list-stacks="aws cloudformation list-stacks --query 'StackSummaries[?StackStatus!=\`DELETE_COMPLETE\`].[StackName,LastUpdatedTime,CreationTime,StackStatus]'"

# from: http://ethertubes.com/bash-snippet-url-encoding/
_s3_urlencode () {
    local tab="$(echo -en "\x9")"
    local i="$@"

    i=${i//%/%25}  ; i=${i//' '/%20} ; i=${i//$tab/%09}
    i=${i//!/%21}  ; i=${i//\"/%22}  ; i=${i//#/%23}
    i=${i//\$/%24} ; i=${i//\&/%26}  ; i=${i//\'/%27}
    i=${i//(/%28}  ; i=${i//)/%29}   ; i=${i//\*/%2a}
    i=${i//+/%2b}  ; i=${i//,/%2c}   ; i=${i//-/%2d}
    i=${i//\./%2e} ; i=${i//\//%2f}  ; i=${i//:/%3a}
    i=${i//;/%3b}  ; i=${i//</%3c}   ; i=${i//=/%3d}
    i=${i//>/%3e}  ; i=${i//\?/%3f}  ; i=${i//@/%40}
    i=${i//\[/%5b} ; i=${i//\\/%5c}  ; i=${i//\]/%5d}
    i=${i//\^/%5e} ; i=${i//_/%5f}   ; i=${i//\`/%60}
    i=${i//\{/%7b} ; i=${i//|/%7c}   ; i=${i//\}/%7d}
    i=${i//\~/%7e}
    echo "$i"
}

# inspired from https://github.com/felixge/s3.sh
s3_signed_url() {
    local bucket=${1}
    local path=${2}
    local expires=${3:-600}

    if echo "$bucket" | grep -q '^s3://'; then
        path="$(echo $bucket | sed 's,^s3://[A-Za-z0-9._-]\+/,,')"
        bucket="$(echo $bucket | sed 's,^s3://\([A-Za-z0-9._-]\+\)/.*$,\1,')"
        expires=${2:-600}
    fi

    if [ -z "$bucket" -o -z "$path" ]; then
        echo "Usage: s3_signed_url <bucket> <path> [<expires>]" 2>&1
        echo "Usage: s3_signed_url s3://<bucket>/<path> [<expires>]" 2>&1
        return 1
    fi

    if [ -z "$AWS_ACCESS_KEY_ID" -o -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "Fatal: \$AWS_ACCESS_KEY_ID and/or \$AWS_SECRET_ACCESS_KEY not set in env" 2>&1
        return 1
    fi

    local httpMethod='GET'
    local awsKey="$AWS_ACCESS_KEY_ID"
    local awsSecret="$AWS_SECRET_ACCESS_KEY"

    # Unix epoch number, defaults to 600 seconds in the future
    # local ts_expires=${expires:-$((`date +%s`+600))}
    local ts_expires=$((`date +%s` + $expires))
    local stringToSign="${httpMethod}\n\n\n${ts_expires}\n/${bucket}/${path}"
    local base64Signature=`echo -en "${stringToSign}" | \
        openssl dgst -sha1 -binary -hmac ${awsSecret} | \
        openssl base64`

    local escapedSignature=`_s3_urlencode ${base64Signature}`
    local escapedAwsKey=`_s3_urlencode ${awsKey}`

    local query="Expires=${ts_expires}&AWSAccessKeyId=${escapedAwsKey}&Signature=${escapedSignature}"
    echo "http://s3.amazonaws.com/${bucket}/${path}?${query}"
}
