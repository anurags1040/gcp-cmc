import googleapiclient.discovery
import time
import base64
import os
from datetime import datetime

def export_job(event, context):

    BUCKET = f"gs://{os.environ.get('BUCKET')}/"
    DATABASE = '${database_name}'
    PROJECT = '${gcp_project_id}'
    FILENAME = "Cloud_SQL_Export_%s" % (datetime.now().strftime("%Y-%m-%d (%H:%M)"))
    REQUEST = {
        "exportContext": { # Database instance export context. # Contains details about the export operation.
          "databases": [],
          "uri": BUCKET+FILENAME,
          "csvExportOptions": { # Options for exporting data as CSV. *MySQL* and *PostgreSQL* instances only.
            "selectQuery": "", # The select query used to extract the data.
          },
          "offload": False, # Option for export offload.
          "fileType": "SQL", # The file type for the specified uri. *SQL*: The file contains SQL statements. *CSV*: The file contains CSV data. *BAK*: The file contains backup data for a SQL Server instance.
          "kind": "sql#exportContext", # This is always *sql#exportContext*.
          "sqlExportOptions": { # Options for exporting data as SQL statements.
            "tables": [],
            "schemaOnly": False, # Export only schemas.
            "mysqlExportOptions": { # Options for exporting from MySQL.
              "masterData": 42, # Option to include SQL statement required to set up replication. If set to *1*, the dump file includes a CHANGE MASTER TO statement with the binary log coordinates, and --set-gtid-purged is set to ON. If set to *2*, the CHANGE MASTER TO statement is written as a SQL comment and has no effect. If set to any value other than *1*, --set-gtid-purged is set to OFF.
            },
          },
        },
      }

    sqladmin = googleapiclient.discovery.build('sqladmin', 'v1beta4')

    sqladmin.instances().export(project=PROJECT, instance=DATABASE, body=REQUEST).execute()

    return

# SDG
