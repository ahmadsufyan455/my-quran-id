import requests
import json
import os

# Ensure the directory exists before writing the file
SAVE_DIR = "assets/datas/surah/"
os.makedirs(SAVE_DIR, exist_ok=True)

def getSurah(surah):
    resp = requests.get(f'https://equran.id/api/v2/surat/{surah}')
    if resp.status_code == 200:
        data = resp.text
        
        # Write data to JSON file
        file_path = os.path.join(SAVE_DIR, f"{surah}.json")
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(data)

        print(f"✅ Saved: {file_path}")

        # Parse JSON to check for next Surah
        jsonObj = json.loads(data)
        if jsonObj['data'].get('suratSelanjutnya'):  # Check if 'suratSelanjutnya' exists
            next_surah = jsonObj['data']['suratSelanjutnya']['nomor']
            getSurah(next_surah)

# Start fetching from Surah 1
getSurah(1)