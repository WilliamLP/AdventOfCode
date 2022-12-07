import sys
import io
import json
import pprint
from google.oauth2 import service_account
from google.cloud import bigquery
from google.cloud.bigquery.job import QueryJobConfig
from google.api_core.exceptions import ClientError

KEYFILEPATH = '/Users/wparker/aoc_bq_keyfile.json'
DATASET = 'wparker_aoc_2022'

def main():
    fname = sys.argv[1]
    tname, ext = fname.split('.')

    client = get_client()

    # Ingest / insert if argument is a .txt file
    # Run it if argument is a .sql file
    if ext == 'txt':
        run(client, f'CREATE OR REPLACE TABLE {tname} (row_num int, input string)')

        with open(fname) as f:
            rows = [line.rstrip() for line in f]
        print(f'INSERTING {len(rows)} ROWS INTO {DATASET}.{tname}')

        # sql += ', '.join([f"({i}, '{val}')" for i, val in enumerate(vals)])
        # 1. Serialize into JSON rows
        json_rows = [json.dumps({'row_num': i, 'input': row}) for i, row in enumerate(rows)]
        print('\n'.join(json_rows))
        # 2. Load rows into BQ
        job_config = bigquery.LoadJobConfig(
            write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
            source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
        )

        job = client.load_table_from_file(
            io.StringIO('\n'.join(json_rows)),
            destination=f'{DATASET}.{tname}',
            job_config=job_config
        )

        try:
            job.result()  # Wait for job to complete.
        except ClientError as e:
            # Log errors, because the exception handler emits a non-useful error message
            print('Job raised errors:', job.errors)
    elif ext == 'sql':
        sql = open(fname).read()
        output = run(client, sql)
        pprint.pprint([dict(row) for row in output])
    else:
        print('Unknown file extension: should be "txt" or "sql"')

def get_client():
    gcs_service_account_keypath = KEYFILEPATH
    gcs_service_account_credentials = service_account.Credentials.from_service_account_file(
        gcs_service_account_keypath, scopes=["https://www.googleapis.com/auth/cloud-platform"])

    print(f'Initializing client with service account: {gcs_service_account_credentials.service_account_email}')
    bigquery_client = bigquery.Client(
        credentials=gcs_service_account_credentials,
        project=gcs_service_account_credentials.project_id)

    return bigquery_client

def run(client, sql):
    print('EXECUTING QUERY\n' + sql)

    job_config = QueryJobConfig(
        default_dataset=f'{client.project}.{DATASET}'
    )
    query_job = client.query(sql, job_config=job_config)
    return list(query_job.result())

main()