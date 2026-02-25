gcc headers.h neural.C render.C selectivePressure.C world.C body.C -o selectivePressure.exe -I SDL3-3.4.2/x86_64-w64-mingw32/include -L SDL3-3.4.2/x86_64-w64-mingw32/lib -lSDL3 -mwindows
cp SDL3-3.4.2/x86_64-w64-mingw32/bin/SDL3.dll SDL3.dll
.\selectivePressure.exe