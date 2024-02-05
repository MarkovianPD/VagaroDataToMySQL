import os
import logging
import pandas as pd
import glob
from datetime import date
from azure.storage.blob import BlobServiceClient
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

key_vault_name = "tradesmainkeyvault"
key_vault_uri = f"https://{key_vault_name}.vault.azure.net/"

credential = DefaultAzureCredential()
secret_client = SecretClient(vault_url=key_vault_uri, credential=credential)

account_url = secret_client.get_secret("vagaro-beebeebeauty-account-url").value
sas_token = secret_client.get_secret("vagaro-beebeebeauty-sas-token").value
container_name = "reports"

blob_service_client = BlobServiceClient(account_url=account_url, credential=sas_token)
container_client = blob_service_client.get_container_client(container_name)

download_dir = "C:/Users/colin/Documents/vagaro-data-lake-db-tool/data-lake-downloads"
os.makedirs(download_dir, exist_ok=True)

today = date.today()
today_formated = today.strftime("%b-%d-%Y")

logs_dir = os.path.join(download_dir, "Download logs")
os.makedirs(logs_dir, exist_ok=True)

log_file_path = os.path.join(logs_dir, f'download_log_{today_formated}.txt')
logging.basicConfig(filename=log_file_path, level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d '
                                                                                                            '%H:%M:%S')

downloaded_files = 0
skipped_files = 0

processed_files_path = os.path.join(download_dir, 'processed_files.txt')
if os.path.exists(processed_files_path):
    with open(processed_files_path, 'r') as file:
        processed_files = set(file.read().splitlines())
else:
    processed_files = set()

blob_list = container_client.list_blobs()
for blob in blob_list:
    local_file_path = os.path.join(download_dir, blob.name.replace('/', os.sep))
    if os.path.exists(local_file_path):
        logging.info(f"{blob.name} already exists, skipping.")
        skipped_files += 1
        continue

    logging.info(f"Downloading {blob.name} to {local_file_path}")

    if blob.name == "Data Lake - Data Dictionary.pdf":
        print(f"Downloading {blob.name} to {local_file_path}")
        blob_client = container_client.get_blob_client(blob)
        with open(local_file_path, "wb") as download_file:
            download_file.write(blob_client.download_blob().readall())
    else:
        parts = blob.name.split('/')
        directory_name = parts[0] if len(parts) > 1 else None

        if directory_name:
            directory_path = os.path.join(download_dir, directory_name)
            os.makedirs(directory_path, exist_ok=True)
            print(f"Downloading {blob.name} to {local_file_path}")
            blob_client = container_client.get_blob_client(blob)
            with open(local_file_path, "wb") as download_file:
                download_file.write(blob_client.download_blob().readall())
        else:
            print(f"No directory specified for blob {blob.name}, skipping.")

    processed_files.add(blob.name)
    downloaded_files += 1

with open(processed_files_path, 'w') as file:
    file.write('\n'.join(processed_files))

summary = f"Download complete. {downloaded_files} files downloaded, {skipped_files} files skipped."
print(summary)
logging.info(summary)

excluded_directories = [
    "Download logs",
    "Customer details",
    "Locations",
    "Logos",
    "Membership details",
    "Service provider details"
]


# noinspection PyUnboundLocalVariable
def combine_csv_files_in_directory(subdir_path):
    csv_files = glob.glob(os.path.join(subdir_path, "*.csv"))
    if not csv_files:
        return

    combined_file_name = f"combined_{os.path.basename(subdir_path)}.csv"
    combined_csv_path = os.path.join(subdir_path, combined_file_name)

    append_data = os.path.exists(combined_csv_path)

    if not append_data:
        combined_csv = pd.DataFrame()

    for file_path in csv_files:
        if os.path.basename(file_path) == combined_file_name:
            continue

        current_csv = pd.read_csv(file_path)

        if append_data:
            current_csv.to_csv(combined_csv_path, mode='a', index=False, header=False, encoding='utf-8-sig')
        else:
            combined_csv = pd.concat([combined_csv, current_csv])

        os.remove(file_path)

    if not append_data:
        combined_csv.to_csv(combined_csv_path, index=False, encoding='utf-8-sig')

    print(f"Data combined into: {combined_csv_path}")


def is_excluded_directory(subdirectory, excluded_dirs):
    return any(excluded_dir in subdirectory for excluded_dir in excluded_dirs)


for subdir, dirs, files in os.walk(download_dir, topdown=True):
    dirs[:] = [d for d in dirs if not is_excluded_directory(os.path.join(subdir, d), excluded_directories)]
    if not dirs and not is_excluded_directory(subdir, excluded_directories):
        combine_csv_files_in_directory(subdir)
