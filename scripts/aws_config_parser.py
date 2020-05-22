#!/usr/bin/env python3
# python script to parse AWS config non-compliant rules and resources
# Resources can be checked against Terraform state file using -w and -f parameters
# file can be obtained via aws state pull command
# check output is writen to XLSX file
# Milan Bednar, 22.5.2020

import boto3
import botocore
import sys
import pandas as pd
import os

DEFAULT_AWS_REGION = "eu-west-1"

def get_rules():
    """
    Gets non-compliant rules from AWS API
    :return: rules list
    """
    rules_list = []
    try:
        paginator = config.get_paginator('describe_compliance_by_config_rule')
        operation_parameters = {'ComplianceTypes': ['NON_COMPLIANT']}
        page_iterator = paginator.paginate(**operation_parameters)
        for page in page_iterator:
            compliance_list = (page['ComplianceByConfigRules'])

            for rule in compliance_list:
                # print(rule['ConfigRuleName'])
                rules_list.append(rule['ConfigRuleName'])

    except botocore.exceptions.ClientError as error:
        print("AWS API call error: "+ str(error))
        raise SystemExit
    except botocore.exceptions.NoCredentialsError as error:
        print("AWS credentials error: "+ str(error))
        raise SystemExit

    return rules_list


def get_resources_for_rule(rule: str):
    """
    Gets non-compliant resources for given rule from AWS API
    :param rule:
    :return: resource dict
    """
    try:
        paginator = config.get_paginator('get_compliance_details_by_config_rule')
        operation_parameters = {'ConfigRuleName': rule, 'ComplianceTypes': ['NON_COMPLIANT']}
        page_iterator = paginator.paginate(**operation_parameters)
        resource_dict = {}

        for page in page_iterator:
            result_list = (page['EvaluationResults'])

            for resource in result_list:
                resource_id = resource['EvaluationResultIdentifier']['EvaluationResultQualifier']['ResourceId']
                resource_type = resource['EvaluationResultIdentifier']['EvaluationResultQualifier']['ResourceType']
                resource_name = get_resource_name(resource_id, resource_type)
                resource_dict[resource_id] = {'ResourceType': resource_type, 'ResourceName': resource_name}

    except botocore.exceptions.ClientError as error:
        print("AWS API call error: "+ str(error))
        raise SystemExit
    except botocore.exceptions.NoCredentialsError as error:
        print("AWS credentials error: "+ str(error))
        raise SystemExit
    return resource_dict


def print_menu():
    """
    Prints menu
    :return:
    """
    print()
    print("Usage:")
    print(script_name + " -p               - to print list of non-compliant AWS config rule names")
    print(script_name + " -r <rule>        - to print list of non-compliant resources for given <rule> name")
    print(script_name + " -w -f <file>     - to check all non-compliant rules and its resources against"
                        " given Terraform state <file> and write result into xlsx file")
    print()
    print("Note:")
    print(" - AWS_DEFAULT_REGION environment variable can be set to change default AWS region (" + DEFAULT_AWS_REGION + ")")
    print(" - Terraform state file can be obtained via 'terraform state pull' command")
    print()

def get_resource_name(resource_id: str, resource_type: str):
    """
    Gets resource name from cache or AWS API
    :param resource_id:
    :param resource_type:
    :return:
    """
    # trying to reuse resource data to minimize API calls
    if resource_id in name_result_cache and name_result_cache[resource_id]['ResourceType'] == resource_type:
        response = name_result_cache[resource_id]['Response']
    else:
        response = config.list_discovered_resources(resourceType=resource_type, resourceIds=[resource_id])

    if len(response['resourceIdentifiers']) > 0 and 'resourceName' in response['resourceIdentifiers'][0]:
        # adding to resource cache
        name_result_cache[resource_id] = {'ResourceType': resource_type, 'Response': response}
        return response['resourceIdentifiers'][0]['resourceName']
    else:
        return ""


def write_xlsx(check_file: str):
    """
    checks resources against TF state file and
    writes non-compliant rules and resources into XLSX file
    :param check_file:
    :return:
    """

    write_file = check_file + ".xlsx"
    writer = pd.ExcelWriter(write_file, engine='xlsxwriter')
    # open check file
    with open(check_file) as f:
        check_content = f.readlines()

    rules_list = get_rules()

    # write overview sheet
    rule_id_list = []
    rule_name_list = []

    max_rule_len = 1

    for rule_id, rule_name in enumerate(rules_list):

        if len(str(rule_name)) > max_rule_len:
            max_rule_len = len(str(rule_name))
        rule_id_list.append(rule_id + 1)
        rule_name_list.append(rule_name)

    overview_dict = {'Status': 'Non-compliant', 'Id': rule_id_list, 'Name': rule_name_list}
    overview_df = pd.DataFrame(overview_dict, columns=['', 'Status', 'Id', 'Name'])
    overview_df.to_excel(writer, index=False, sheet_name='Rules overview')

    # sheet formating
    worksheet = writer.sheets['Rules overview']
    worksheet.set_column('A:A', 4)
    worksheet.set_column('B:B', 15)
    worksheet.set_column('C:C', 8)
    worksheet.set_column('D:D', max_rule_len + 2)

    # write sheet for each rule
    for rule_id, rule_name in enumerate(rules_list):
        resource_dict = get_resources_for_rule(rule_name)

        check_result_list = []
        resource_type_list = []
        resource_name_list = []

        id_max_len = 15
        type_max_len = 15
        name_max_len = 15

        # rule resources
        for resource_id, params in resource_dict.items():
            found = False
            resource_type_list.append(params['ResourceType'])
            resource_name_list.append(params['ResourceName'])

            # setting column width
            if len(str(resource_id)) > id_max_len:
                id_max_len = len(str(resource_id))
            if len(str(params['ResourceType'])) > type_max_len:
                type_max_len = len(str(params['ResourceType']))
            if len(str(params['ResourceName'])) > name_max_len:
                name_max_len = len(str(params['ResourceName']))

            # resource ID check against TF state file
            for check_line in check_content:
                if str.strip(resource_id) in check_line:
                    check_result_list.append("true")
                    found = True
                    break
            if not found:
                check_result_list.append("false")

        checked_resources = {'Resource type': resource_type_list,
                             'ResourceId': list(resource_dict.keys()), 'ResourceName': resource_name_list,
                             'Found in TF state': check_result_list}

        df = pd.DataFrame(checked_resources, columns=['', 'Resource type', 'ResourceId', 'ResourceName',
                                                      'Found in TF state'])
        sheet_name = str(rule_id + 1) + "_" + rule_name
        sheet_name = sheet_name[:31]  # excel max sheet name length

        df.to_excel(writer, index=False, sheet_name=sheet_name)

        # sheet formating
        worksheet = writer.sheets[sheet_name]
        worksheet.set_column('A:A', 4)
        worksheet.set_column('B:B', type_max_len + 2)
        worksheet.set_column('C:C', id_max_len + 2)
        worksheet.set_column('D:D', name_max_len + 2)
        worksheet.set_column('E:E', 16)

    writer.save()
    print(str(len(rules_list)) + " non-compliant rule results written into file: " + write_file)


def print_resources_for_rule(rule: str):
    """
    Prints non-compliant resources for rule given
    :param rule:
    :return:
    """
    resource_dict = get_resources_for_rule(rule)
    # print(id_list)
    if len(resource_dict) > 0:

        print("Total non-compliant resources: for rule: " + rule + " " + str(len(resource_dict)))
        print()
        for resource, params in resource_dict.items():
            print(
                "ResourceType: " + params['ResourceType'] + ", ResourceID: " + resource + ",  ResourceName: " + params[
                    'ResourceName'])
    else:
        print("No resources found for rule: " + rule)


# **************** MAIN START **********************

script_name=os.path.basename(__file__)
AWS_REGION = os.getenv('AWS_DEFAULT_REGION', DEFAULT_AWS_REGION)

print(script_name)
print("AWS region: " + AWS_REGION)

config = boto3.client('config', region_name= AWS_REGION)
name_result_cache = {}



if len(sys.argv) == 2:
    # print rules
    if sys.argv[1] == "-p":
        rules_list = get_rules()
        print("Non-compliant rules count: " + str(len(rules_list)))
        print()
        for rule in rules_list:
            print(rule)
    else:
        print_menu()

elif len(sys.argv) == 3:
    # print resources    
    if sys.argv[1] == "-r":
        print_resources_for_rule(sys.argv[2])
    else:
        print_menu()

elif len(sys.argv) == 4:
    # write all rules and resources to XLSX
    if sys.argv[1] == "-w":
        write_xlsx(sys.argv[3])
    else:
        print_menu()
else:
    print_menu()
