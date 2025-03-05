project('hypr-dialog', 'cpp',
  version: '0.1',
  default_options: ['warning_level=3'])

imgui = dependency('imgui', version: '>=1.90')
glfw = dependency('glfw3', version: '>=3.3')
gles2 = dependency('glesv2', version: '>=3.2')

imgui_compile_args = []

executable('hypr-donate-pls', 'main.cpp',
  cpp_args: imgui_compile_args,
  dependencies: [imgui, glfw, gles2],
  install: true)
