import boto3
import logging
import json
import os

log = logging.getLogger()
log.setLevel(logging.INFO)

# *********** VARIABLES ************
SNS_SUBJECT = "AWS Config non-compliant rules report"

# *********** FROM ENV ************

SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']


# *********** METHODS ************

def get_non_compliant_rules():
    """
    returns AWS config service non-compliant rules and resources count
    """
    config = boto3.client('config')
    non_compliant_rules = {}
    paginator = config.get_paginator('describe_compliance_by_config_rule')
    operation_parameters = {'ComplianceTypes': ['NON_COMPLIANT']}
    page_iterator = paginator.paginate(**operation_parameters)
    for page in page_iterator:
        compliance_list = (page['ComplianceByConfigRules'])

        for rule in compliance_list:
            non_compliant_rules[rule['ConfigRuleName']] = rule['Compliance']['ComplianceContributorCount'][
                'CappedCount']
    return non_compliant_rules


def sns_publish_report(sns_topic_arn, subject, msg):
    """
    publishes report link to SNS topic
    """
    sns = boto3.client('sns')
    response = sns.publish(
        TargetArn=sns_topic_arn,
        Subject=subject,
        Message=json.dumps({'default': json.dumps(msg)}),
        MessageStructure='json'
    )
    return response


# *********** LAMBDA ENTRY POINT ************
def lambda_handler(event, context):
    log.debug('Event: %s', event)
    log.debug('Context: %s', context)

    non_compliant_rules = get_non_compliant_rules()
    # TODO fix message content
    message =" AWS config non-compliant rules count: "+str(len(non_compliant_rules)) + ", details: " + json.dumps(non_compliant_rules)
    publish_response = sns_publish_report(SNS_TOPIC_ARN, SNS_SUBJECT, message)
    log.info('SNS publish response: %s', publish_response)
