SET SDL_PATH=SDL3-3.4.2/x86_64-w64-mingw32
SET SDL_TTF_PATH=SDL3_ttf-3.2.2

gcc headers.h neural.C render.C selectivePressure.C world.C body.C -o selectivePressure.exe -I %SDL_PATH%/include -I %SDL_TTF_PATH%/include -L %SDL_PATH%/lib -L %SDL_TTF_PATH% -lSDL3 -lSDL3_ttf -mwindows
rem cp SDL3-3.4.2/x86_64-w64-mingw32/bin/SDL3.dll SDL3.dll 
.\selectivePressure.exe