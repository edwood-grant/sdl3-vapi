# SDL_shadercross

To compile these shaders is recommended to use the SDL tool shadercross
https://github.com/libsdl-org/SDL_shadercross

This is a handy utili to grab shaders in *.hlsl format and convert them to the
main shader languages.

* SPIRV (.spv) for Vulkan
* DXIL (.dxil) for Microsoft DirectX12
* MSL (.msl) For MacOS Metal

## Compiling and installing shadercross

To install shadercross you cna use this build script that will compile and
install it for you:

https://gist.github.com/trojanfoe/aae4fe796c7bb8a58fd53d6562b4400d

Don't forget to modfiy the details inside the script to your liking. I recommend
you to study he script if you want to see how to properly compile
SDL_shadercross yourself.

## Using Shadercross

You invoke shadercross like this 

// Vulkan SPIRV Shaders
shadercross <filename> -o <output>.spv

// Metal MSL Shaders
shadercross <filename> -o <output>.msl

// Direct3D12 DXIL shaders
shadercross <filename> -o <output>.dxil

You can also include shadercross and use it at runtime, but it rqeuires
including it yourself and incurs in performance cost. Read the github repository
for more information about shadercross compiling and using appropiately