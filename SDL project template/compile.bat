SET SDL_PATH=SDL3-3.4.2/x86_64-w64-mingw32

gcc simpleText.C -o simpleText.exe -I %SDL_PATH%/include -L %SDL_PATH%/lib -lSDL3 -mwindows
rem cp SDL3-3.4.2/x86_64-w64-mingw32/bin/SDL3.dll SDL3.dll 
.\simpleText.exe