import sys

# Open the raw binary file
with open("program.bin", "rb") as f, open("instruction_set.hex", "w") as out:
    while True:
        # Read 4 bytes (32 bits) at a time
        chunk = f.read(4)
        if not chunk:
            break
        
        # Pad with zeros if the last chunk is less than 4 bytes
        chunk += b'\x00' * (4 - len(chunk))
        
        # Convert to a little-endian hex string and write to file
        hex_str = f"{int.from_bytes(chunk, byteorder='little'):08x}\n"
        out.write(hex_str)

print("Successfully generated instruction_set.hex!")