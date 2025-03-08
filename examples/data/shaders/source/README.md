To compile these shader is recommended to use the SDL tool shadercross
https://github.com/libsdl-org/SDL_shadercross

You invoke shadercross like this

// Vulkan SPIRV Shaders
shadercross <filename> -o <output>.spv
// Metal MSL Shaders
shadercross <filename> -o <output>.msl
// Direct3D12 DXIL shaders
shadercross <filename> -o <output>.dxil

You can also include shadercross and use it at runtime, but it rqeuires
including it yourself and incurs in performance cost

Read the github repository for more information about shadercross compiling and
using appropiately