import requests
import json
import os

# Ensure the directory exists before writing the file
SAVE_DIR = "assets/datas/surah/"
os.makedirs(SAVE_DIR, exist_ok=True)

def getSurah(nomor):
    print(f"📥 Fetching Surah {nomor}...")
    resp = requests.get(f'https://equran.id/api/v2/surat/{nomor}')
    
    if resp.status_code == 200:
        data = resp.text
        
        # Write data to JSON file
        file_path = os.path.join(SAVE_DIR, f"{nomor}.json")
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(data)

        print(f"✅ Saved: {file_path}")

        # Parse JSON to check for next Surah
        jsonObj = json.loads(data)
        if jsonObj['data'].get('suratSelanjutnya'):  # Check if 'suratSelanjutnya' exists
            next_surah = jsonObj['data']['suratSelanjutnya']['nomor']
            getSurah(next_surah)
        else:
            print(f"🎉 Completed! All 114 Surahs have been downloaded.")
    else:
        print(f"❌ Error fetching Surah {nomor}: HTTP {resp.status_code}")

# Start fetching from Surah 1
print("🚀 Starting to crawl Quran data from equran.id...")
getSurah(1)