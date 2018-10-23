import boto
from boto.s3.key import Key
s3 = boto.connect_s3(aws_access_key_id='2EGEPIX6I99ZEYHG3HU0',
                     aws_secret_access_key='lrebwY8NoggD1YukKdfrWceoACM3sH7WtVHeU0Ls',
                     host='s3-china-1.eecloud.nsn-net.net',
                     is_secure=False)
print s3.get_all_buckets()
bucket = s3.get_bucket('test')
k = Key(bucket)
possible_key = bucket.get_key('mykey', validate=False)
print possible_key
