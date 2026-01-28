
import csv
import os

# Define file paths
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
                 coordinates[sid] = {'Latitude': lat, 'Longitude': lon}
    return coordinates


def update_file(filepath, coords_map):
    print(f"Processing {filepath}...")
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return

    # Read original data
    with open(filepath, mode='r', encoding='utf-8-sig', newline='') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        rows = list(reader)

    # Check if we need to add columns or rename
    # User requested "Lat" and "Long"
    
    new_fieldnames = []
    for f in fieldnames:
        if f == 'Latitude':
            new_fieldnames.append('Lat')
        elif f == 'Longitude':
            new_fieldnames.append('Long')
        else:
            new_fieldnames.append(f)
            
    if 'Lat' not in new_fieldnames:
        new_fieldnames.append('Lat')
    if 'Long' not in new_fieldnames:
        new_fieldnames.append('Long')

    updated_count = 0
    
    # Update rows
    updated_rows = []
    for row in rows:
        new_row = {}
        # Copy data, renaming keys
        for k, v in row.items():
            if k == 'Latitude':
                new_row['Lat'] = v
            elif k == 'Longitude':
                new_row['Long'] = v
            else:
                new_row[k] = v
        
        sid = row.get('SchoolID')
        if sid:
            sid_clean = sid.strip()
            if sid_clean in coords_map:
                new_row['Lat'] = coords_map[sid_clean]['Latitude']
                new_row['Long'] = coords_map[sid_clean]['Longitude']
                updated_count += 1
        
        updated_rows.append(new_row)
    
    # Write back
    with open(filepath, mode='w', encoding='utf-8-sig', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=new_fieldnames)
        writer.writeheader()
        writer.writerows(updated_rows)
        
    print(f"Updated {updated_count} rows in {filepath}")

if __name__ == "__main__":
    coords_map = load_coordinates(coords_file)
    print(f"Loaded {len(coords_map)} coordinates.")
    
    for f in target_files:
        update_file(f, coords_map)
