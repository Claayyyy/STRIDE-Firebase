
import csv
import os

coords_file = 'school_coordinates.csv'
target_files = ['School-Unique-48k.csv', 'EFD-DataBuilder-2025.csv', 'uni123.csv']

def load_coordinates(filepath):
    coordinates = {}
    with open(filepath, mode='r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        for row in reader:
            sid = row.get('SchoolID')
            lat = row.get('Latitude')
            lon = row.get('Longitude')
            if sid and lat and lon and lat != 'NA' and lon != 'NA':
                 coordinates[sid] = {'Lat': lat, 'Long': lon}
    return coordinates

def update_and_rename(filepath, coords_map):
    print(f"Processing {filepath}...")
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return

    with open(filepath, mode='r', encoding='utf-8-sig', newline='') as f:
        reader = csv.DictReader(f)
        original_fieldnames = reader.fieldnames
        rows = list(reader)

    # Construct new fieldnames: Replace Latitude->Lat, Longitude->Long, or append Lat/Long
    new_fieldnames = []
    
    # helper to check if we already processed a lat/long column
    added_lat = False
    added_long = False

    for f in original_fieldnames:
        if f == 'Latitude':
            new_fieldnames.append('Lat')
            added_lat = True
        elif f == 'Longitude':
            new_fieldnames.append('Long')
            added_long = True
        elif f == 'Lat':
            new_fieldnames.append('Lat')
            added_lat = True
        elif f == 'Long':
            new_fieldnames.append('Long')
            added_long = True
        else:
            new_fieldnames.append(f)
    
    if not added_lat:
        new_fieldnames.append('Lat')
    if not added_long:
        new_fieldnames.append('Long')

    # Remove duplicates if any (e.g. if Lat and Latitude both existed)
    # We want unique field names, prioritizing the first "Lat" we found or created
    final_fieldnames = []
    seen = set()
    for f in new_fieldnames:
        if f not in seen:
            final_fieldnames.append(f)
            seen.add(f)
    
    updated_count = 0
    updated_rows = []

    for row in rows:
        new_row = {}
        # Map old keys to new keys
        for k, v in row.items():
            if k == 'Latitude':
                new_row['Lat'] = v
            elif k == 'Longitude':
                new_row['Long'] = v
            else:
                # If key was 'Lat' or 'Long', it stays 'Lat'/'Long'
                # If key was something else, it stays.
                new_row[k] = v
        
        # Inject updates
        sid = row.get('SchoolID')
        if sid:
            sid_clean = sid.strip()
            if sid_clean in coords_map:
                new_row['Lat'] = coords_map[sid_clean]['Lat']
                new_row['Long'] = coords_map[sid_clean]['Long']
                updated_count += 1
        
        updated_rows.append(new_row)

    with open(filepath, mode='w', encoding='utf-8-sig', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=final_fieldnames)
        writer.writeheader()
        writer.writerows(updated_rows)
        
    print(f"Updated {updated_count} rows in {filepath}")

if __name__ == "__main__":
    coords = load_coordinates(coords_file)
    print(f"Loaded {len(coords)} coordinates.")
    for f in target_files:
        update_and_rename(f, coords)
