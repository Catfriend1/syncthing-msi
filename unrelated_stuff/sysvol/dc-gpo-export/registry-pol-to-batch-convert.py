import struct

def hex2utf16le(hex_str):
    """Convert a hex string to a UTF-16LE string and remove trailing null characters."""
    string = bytes.fromhex(hex_str).decode('utf-16le')
    return string.rstrip('\x00')  # Strip trailing null characters

def hex2int32le(hex_str):
    """Convert a hex string to a 32-bit little-endian integer."""
    return struct.unpack('<L', bytes.fromhex(hex_str))[0]

def hex2int64le(hex_str):
    """Convert a hex string to a 64-bit little-endian integer."""
    return struct.unpack('<Q', bytes.fromhex(hex_str))[0]

def parse_pol_file(file_path):
    """Parse a .POL file and output the registry modifications, removing null terminators."""
    with open(file_path, 'rb') as f:
        content = f.read()

    # Check header
    signature, version = struct.unpack('<LL', content[:8])
    if signature != 0x67655250:  # 'PReg'
        raise ValueError("Invalid file signature")
    if version != 1:
        raise ValueError("Unsupported version")

    pos = 8
    entries = []
    while pos < len(content):
        # Reading each record bracketed by '[' and ']'
        if content[pos:pos+2] == b'[\x00':
            pos += 2
            end_pos = content.find(b']\x00', pos)
            if end_pos == -1:
                break
            record = content[pos:end_pos]
            parts = record.split(b';\x00')
            if len(parts) < 5:
                pos = end_pos + 2
                continue

            key = hex2utf16le(parts[0].hex())
            value = hex2utf16le(parts[1].hex())
            data_type = hex2int32le(parts[2].hex())
            data_size = hex2int32le(parts[3].hex())
            data_hex = parts[4].hex()

            # Handle data based on type
            if data_type == 1:  # REG_SZ
                data = hex2utf16le(data_hex)
            elif data_type == 4:  # REG_DWORD
                data = hex2int32le(data_hex)
            elif data_type == 11:  # REG_QWORD
                data = hex2int64le(data_hex)
            else:
                data = data_hex  # For other types, keep as hex for now

            entries.append({
                'Key': key,
                'Value': value,
                'Type': data_type,
                'Size': data_size,
                'Data': data
            })

            pos = end_pos + 2
        else:
            pos += 2

    return entries

def generate_batch_script(regRoot, entries):
    """Generate a batch script for REG ADD and REG DELETE commands based on registry entries."""
    lines = []
    for entry in entries:
        key = entry['Key']
        value = entry['Value']
        type_map = {
            1: 'REG_SZ',
            2: 'REG_EXPAND_SZ',
            4: 'REG_DWORD',
            7: 'REG_MULTI_SZ',
            11: 'REG_QWORD'
        }
        data_type = type_map.get(entry['Type'], 'REG_SZ')
        if value == '**delvals.':
            line = f'REG DELETE "{regRoot}{key}" /f'
        else:
            entry_data = entry['Data']
            line = f'REG ADD "{regRoot}{key}" /v "{value}" /t {data_type} /d "{entry_data}" /f'
        lines.append(line)
        print(line)

    with open("output_batch_script.cmd", "w") as f:
        f.write("\n".join(lines))

# Example usage:
file_path = 'X:\Registry.pol'
parsed_entries = parse_pol_file(file_path)
generate_batch_script("HKLM\\", parsed_entries)
print("Batch script generated successfully.")
