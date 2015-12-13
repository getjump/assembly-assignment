## Assembly assignments, during 5th semester of education

Almost all was realized using NASM on OSX.

You can run any Assembly from here on OSX with following command:
```bash
nasm -g -f macho ${file} && 
  ld -o ${file_path}/${file_base_name} ${file_path}/${file_base_name}.o -arch i386 -lc -macosx_version_min 10.6 &&
  ./${file_base_name}`
```

NASM, GCC and other things could be installed using [Brew🍺](http://brew.sh)

Remember to keep stack 16-bytes aligned, or you will get Segmentation Faults 😉
