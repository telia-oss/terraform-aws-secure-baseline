#
#
# Description: Check that all the RDS instances have a snapshot created in past day
#
# Trigger Type: Periodic check
# Scope of Changes: RDS:DBInstance
# Accepted Parameters: None


import boto3
import json
import logging
import time

log = logging.getLogger()
log.setLevel(logging.INFO)


def evaluate_compliance():

    client = boto3.client("rds")

    # collecting info about rds instances
    dbs = client.describe_db_instances(MaxRecords=100)
    db_instances = dbs['DBInstances']
    while len(dbs['DBInstances']) and 'nextToken' in dbs:
        dbs = client.describe_db_instances(nextToken=dbs['nextToken'])
        db_instances += dbs['DBInstances']

    non_complient_list = []

    dbs = client.describe_db_instances(
        MaxRecords=100,
    )
    for db in dbs['DBInstances']:
        logging.info("Fetching snapshots for " + str(db['DBInstanceIdentifier']))

        # collecting info about rds instance's snapshots
        dbsnaps = client.describe_db_snapshots(DBInstanceIdentifier=db['DBInstanceIdentifier'])
        db_snapshots = dbsnaps['DBSnapshots']
        while len(dbsnaps['DBSnapshots']) and 'nextToken' in dbsnaps:
            dbsnaps = client.describe_db_instances(nextToken=dbsnaps['nextToken'])
            db_snapshots += dbsnaps['DBSnapshots']
        db_snapshots = [
            snap for snap in db_snapshots if snap['SnapshotCreateTime'].timestamp() > (time.time() - 24*60*60)
        ]
        if len(db_snapshots) == 0:
            non_complient_list.append(db['DBInstanceIdentifier'])

    Evaluations = []
    for i in dbs['DBInstances']:
        if i['DBInstanceIdentifier'] in non_complient_list:
            Evaluations.append(
                {
                    "ComplianceType": "NON_COMPLIANT",
                    "Annotation": "Instances does not have have daily snapshots",
                    "OrderingTimestamp": time.time(),
                    "ComplianceResourceType": "AWS::RDS::DBInstance",
                    "ComplianceResourceId": i["DBInstanceIdentifier"]
                }
            )
        else:
            Evaluations.append(
                {
                    "ComplianceType": "COMPLIANT",
                    "Annotation": "Instance have daily snapshots",
                    "OrderingTimestamp": time.time(),
                    "ComplianceResourceType": "AWS::RDS::DBInstance",
                    "ComplianceResourceId": i["DBInstanceIdentifier"]
                }
            )
    return Evaluations


def lambda_handler(event, context):
    log.debug('Event %s', event)
    config = boto3.client('config')

    response = config.put_evaluations(
       Evaluations=evaluate_compliance(),
       ResultToken=event['resultToken']
    )