import boto3    # AWS connection


# Allows connection to Amazon S3
# Dependency: connect AWS CLI using Access Key & Secret Key
def s3_connect():
    return boto3.client('s3')


def print_functions():
    print('S3 Commands: \n'
          '\tlist_s3_buckets() | returns list of existing buckets in S3 \n'
          '\ts3_bucket_exists(bucket_name: string) | return bool showing existence of bucket in s3 \n'
          '\ts3_create_bucket(new_bucket_name: string, region_name: string *optional*) | creates new bucket \n'
          '\ts3_delete_bucket(bucket_name: string) | deletes selected bucket if exists')
    return 0


def s3_list_buckets() -> list:
    existing_buckets = []
    conn = s3_connect()
    response = conn.list_buckets()

    for bucket in response['Buckets']:
        existing_buckets.append(bucket["Name"])

    return existing_buckets


def s3_bucket_exists(bucket_name: str) -> bool:
    if bucket_name in s3_list_buckets():
        return True
    return False


def s3_create_bucket(bucket_name: str, region=None, acl='private'):
    if s3_bucket_exists(bucket_name):
        print(f'{bucket_name} bucket already exists')
        return -1

    conn = s3_connect()
    if region is None:
        response = conn.create_bucket(ACL=acl, Bucket=bucket_name)
    else:
        location = {'LocationConstraint': region}
        response = conn.create_bucket(ACL=acl, Bucket=bucket_name, CreateBucketConfiguration=location)

    print(f'{bucket_name} has been created')
    return 1


def s3_delete_bucket(bucket_name: str):
    if s3_bucket_exists(bucket_name):
        conn = s3_connect()

        # check if bucket is empty before deleting bucket
        bucket_objects = conn.list_objects_v2(Bucket=bucket_name)
        file_count = bucket_objects['KeyCount']

        if file_count == 0:
            response = conn.delete_bucket(Bucket=bucket_name)

            print(f'{bucket_name} was deleted')
            return response
        else:
            print(f'{bucket_name} has {file_count} existing files, please remove before deleting bucket')
            return -1

    else:
        print(f'{bucket_name} does not exist')
        return -1
