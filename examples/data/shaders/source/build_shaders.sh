#!/usr/bin/env bash

# Requires shadercross CLI installed from SDL_shadercross
for filename in *.vert.hlsl; do
    if [ -f "$filename" ]; then
        echo "Converting $filename"
        shadercross "$filename" -o "../compiled/SPIRV/${filename/.hlsl/.spv}"
        shadercross "$filename" -o "../compiled/MSL/${filename/.hlsl/.msl}"
        shadercross "$filename" -o "../compiled/DXIL/${filename/.hlsl/.dxil}"
    fi
done

for filename in *.frag.hlsl; do
    if [ -f "$filename" ]; then
        echo "Converting $filename"
        shadercross "$filename" -o "../compiled/SPIRV/${filename/.hlsl/.spv}"
        shadercross "$filename" -o "../compiled/MSL/${filename/.hlsl/.msl}"
        shadercross "$filename" -o "../compiled/DXIL/${filename/.hlsl/.dxil}"
    fi
done

for filename in *.comp.hlsl; do
    if [ -f "$filename" ]; then
        echo "Converting $filename"
        shadercross "$filename" -o "../compiled/SPIRV/${filename/.hlsl/.spv}"
        shadercross "$filename" -o "../compiled/MSL/${filename/.hlsl/.msl}"
        shadercross "$filename" -o "../compiled/DXIL/${filename/.hlsl/.dxil}"
    fi
done

echo "Finished!"