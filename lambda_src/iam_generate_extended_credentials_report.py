# parses user login records from AWS API 

import boto3
import botocore
from botocore.exceptions import ClientError
import csv
import time


iam = boto3.client('iam')
output_file="/tmp/aws-users-creds.csv"
output_csv_lines = []

CSV_DELIMITER=","
BUCKET_NAME = 'iam-report'  # replace with your bucket name
KEY = 'OUTPUT.csv'          # replace with your object key


# *********** METHODS ************

def parse_iam_report_row(row):
    '''
    selects interesting columns from IAM credentials report
    '''
    # ['user', 'arn', 'user_creation_time', 'password_enabled', 'password_last_used', 'password_last_changed', 'password_next_rotation', 'mfa_active', 'access_key_1_active', 'access_key_1_last_rotated', 'access_key_1_last_used_date', 'access_key_1_last_used_region', 'access_key_1_last_used_service', 'access_key_2_active', 'access_key_2_last_rotated', 'access_key_2_last_used_date', 'access_key_2_last_used_region', 'access_key_2_last_used_service', 'cert_1_active', 'cert_1_last_rotated', 'cert_2_active', 'cert_2_last_rotated']
    parsed_columns = [row[0],row[1],row[3],row[4],row[8],row[10],row[13],row[15]]
    return(parsed_columns)

def get_user_group_names(user_name):
    '''
    returns user group names
    '''
    user_groups_response=iam.list_groups_for_user(UserName=user_name)
    group_list = user_groups_response["Groups"]
    group_names=""
    for group in group_list:
        group_names+=str(group["GroupName"] + " ")
    return group_names

def get_user_policies_names(user_name):
    '''
    returns user attached policies names
    '''
    user_policies_response=iam.list_attached_user_policies(UserName=user_name)
    policies_list = user_policies_response["AttachedPolicies"]
    policies_names=""
    for policy in policies_list:
        policies_names+=str(policy["PolicyName"] + " ")
    return policies_names

def get_group_policies(group_names):
    '''
    returns groups attached policies
    '''
    #TODO algorithm optimalization needed
    group_list=group_names.split(" ")
    all_group_policies=""
    for group in group_list:
        group_policies_response=iam.list_attached_group_policies(GroupName=group)
        group_policies_list = group_policies_response["AttachedPolicies"]
        group_policies_names=""
        for policy in group_policies_list:
            group_policies_names+=str(policy["PolicyName"] + " ")
            all_group_policies+=group_policies_names
    return all_group_policies

def convert_to_bytes(csv_lines: list):
    '''
    converts list of lines to bytes
    '''
  bytes_str=bytes()
  for line in csv_lines:
      for index,item in enumerate(line):
          if index < len(line)-1:
              bytes_str+=str(item).encode() + CSV_DELIMITER.encode()
          else:
              bytes_str+=str(item).encode()+"\r\n".encode()
  return bytes_str

def generate_iam_report():
    '''
    generates IAM credentials report
    '''
    #TODO remove endless loop
    while True:
        # generate report (possible every 4 hours)
        generate_response = iam.generate_credential_report()
        state= generate_response['State']
        print("Generate status: "+ state)
        if state == "COMPLETE":
            break
        time.sleep(1)
    # get credential report
    report=iam.get_credential_report()
    report_content=report['Content'].decode()
    return report_content

def prepare_extended_iam_report(iam_report):
    '''
    extends default IAM report with:
        - user group names
        - user attached policies
        - group attached policies
    '''
    csv_reader = csv.reader(iam_report.split('\n'), delimiter =',')
    lines = 0
    # read credentials report
    for row in csv_reader:
    
            # header
            if lines == 0:
                row=parse_report_row(row)
                row.append("user groups")
                row.append("user policies")
                row.append("group policies")
                output_csv_lines.append(row)
    
            # root user
            elif row[0]  == "<root_account>":
                row=parse_report_row(row)
                output_csv_lines.append(row)
    
            # regular users
            else:
                # select interesting columns
                row=parse_report_row(row)
                # add user group names
                group_names=get_user_group_names(row[0])
                row.append(group_names.strip())
                # add user policies
                user_policies_names=get_user_policies_names(row[0])
                row.append(user_policies_names.strip())
                # add group policies
                # TODO can be optimalized via global policies list (not only per user)
                group_policies_names=get_group_policies(group_names.strip())
                row.append(group_policies_names.strip())
                output_csv_lines.append(row)
    
            lines += 1
            # end for
    return output_csv_lines

def write_report(report: list, filename: str):
    '''
    writes report to file
    '''
    
    with open(output_file, mode='w') as csv_file:
        csv_writer = csv.writer(csv_file, delimiter=',', quotechar='"')
        for row in report:
            csv_writer.writerow(row)
    #TODO - return OK if success
            
            
def write_report_s3(report, bucket_name, bucket_key):
    '''
    writes report to s3 bucket and returns download URL
    '''
    csv_binary = convert_to_bytes(report)
    try:
        s3= boto3.resource('s3') 
        obj = s3.Object(BUCKET_NAME, KEY)
        obj.put(Body=csv_binary)
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            print("The object does not exist.")
        else:
            raise
    s3client = boto3.client('s3')
    try:
        download_url = s3client.generate_presigned_url(
                         'get_object',
                          Params={
                              'Bucket': BUCKET_NAME,
                              'Key': KEY
                              },
                          ExpiresIn=3600
        )
    except Exception as e:
        raise utils_exception.ErrorResponse(400, e, Log)
    return download_url
    
# *********** METHODS END ************


# *********** LAMBDA ENTRY POINT ************
def lambda_handler(event, context):
    iam_report=generate_iam_report()

    extended_report=prepare_extended_iam_report(iam_report)
    
    download_url=write_report_s3(extended_report,BUCKET_NAME,KEY)

    return {"csv_link": download_url}
