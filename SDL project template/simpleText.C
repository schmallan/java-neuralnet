#define SDL_MAIN_USE_CALLBACKS 1  /* use the callbacks instead of main() */
#include <windows.h>
#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>

 SDL_Renderer *renderer = NULL;
 SDL_Window *window = NULL;
 int screenWidth;
 int screenHeight;

/* This function runs once at startup. */
SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[])
{   
    //SDL_SetWindowFullscreenMode(window,&disMode);
    //const SDL_DisplayMode disMode = NULL;
    
    SDL_SetAppMetadata("simpleText", "1.0", "com.example.renderer-debug-text");

    if (!SDL_Init(SDL_INIT_VIDEO)) { return SDL_APP_FAILURE; }
    if (!SDL_CreateWindowAndRenderer("simpleText", -1, -1, SDL_WINDOW_FULLSCREEN, &window, &renderer))  { return SDL_APP_FAILURE; }

    //dont add this...
   // SDL_SetRenderLogicalPresentation(renderer, screenWidth, screenHeight, SDL_LOGICAL_PRESENTATION_LETTERBOX);
   //getwindowsizepixel?
   SDL_GetWindowSize(window,&screenWidth,&screenHeight);
   // screenWidth = 500;//disMode.w;
    //screenHeight = 500;//disMode.h;

    return SDL_APP_CONTINUE;  /* carry on with the program! */
}


/* This function runs when a new event (mouse input, keypresses, etc) occurs. */
SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event)
{
    SDL_Event myevent = *event;

    if (myevent.type == SDL_EVENT_QUIT) {
        return SDL_APP_SUCCESS;  /* end the program, reporting success to the OS. */
    }
    return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once per frame, and is the heart of the program. */
SDL_AppResult SDL_AppIterate(void *appstate)
{
    SDL_RenderPresent(renderer);
    return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once at shutdown. */
void SDL_AppQuit(void *appstate, SDL_AppResult result)
{
    /* SDL will clean up the window/renderer for us. */
}
