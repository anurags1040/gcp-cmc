import googleapiclient.discovery
import time
import base64

def backup_job(event, context):
    ### Script that maintains the last 10 backups in Cloud SQL for a given Database
    ### A SVC account with CloudSQL Admin role is required

    DATABASE = '${database_name}'
    PROJECT = '${gcp_project_id}'

    sqladmin = googleapiclient.discovery.build('sqladmin', 'v1beta4')

    backupslist = sqladmin.backupRuns().list(project=PROJECT, instance=DATABASE).execute()

    backupcount = len(backupslist["items"])

    if backupcount >= 10:
        for backup in range(backupcount):
            oldestbackupid = backupslist["items"][backupcount - 1]["id"]
            sqladmin.backupRuns().delete(project=PROJECT, instance=DATABASE, id=oldestbackupid ).execute()
            backupcount -= 1
            if backupcount < 10:
                time.sleep(40)
                sqladmin.backupRuns().insert(project=PROJECT, instance=DATABASE).execute()
                break
    else:
        sqladmin.backupRuns().insert(project=PROJECT, instance=DATABASE).execute()

    return

# SDG
