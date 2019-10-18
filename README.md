# AWS S3 Log Migration Script
### Automated script for sending logs from EC2 to S3

Small bash script for running on a schedule inside an EC2 instance, for sending
logs (or anything really) to S3 as a zip file.

## Setup
1. SCP the logger.sh script to the EC2 instance
2. Change the file permissions so it is executable: **chmod u+x logger.sh**
3. Create a Cron task: **crontab -e** (you can use a simple cron generator)
4. Save the task.

## Configuration
1. Optionally replace **logs_dir=Logs** with your directory path to store the logs in S3
2. Optionally replace **file=$today.tar.gz** with the name of the log zip file (currently set to the log zip date)
3. Replace **bucket=s3-bucket-name** with your log storage bucket name.
4. Replace **s3_key=access-key** and **s3_bucket=secret-access-key** keys with your own user keys.
5. Replace **region=eu-west-1** with your bucket region.

When starting the script for the first time (or the configs have been deleted),
you will be promopted to add the log file locations. You'll need to use the absolute
paths and seperate each path by a space, for example; **/var/log/pacman.log** **/var/log/containers**

#### Thanks to tmont for the S3 PUT configuration - of which can be found [here](http://tmont.com/blargh/2014/1/uploading-to-s3-in-bash)
