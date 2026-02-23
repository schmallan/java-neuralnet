#define SDL_MAIN_USE_CALLBACKS 1  /* use the callbacks instead of main() */
#include <SDL3/SDL.h>
#include "headers.h"
#include <SDL3/SDL_main.h>
#include <stdio.h>

static SDL_Renderer *renderer;
static SDL_Window *window;

#define WINDOW_WIDTH 640
#define WINDOW_HEIGHT 480


void error(){
    const char* ems = SDL_GetError();
    printf("error: %s\n",ems);
}

/* This function runs once at startup. */
SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[])
{
    SDL_SetAppMetadata("Selective Pressure", "1.0", "com.example.renderer-debug-text");

    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("Couldn't initialize SDL: %s", SDL_GetError());
        return SDL_APP_FAILURE;
    }

    if (!SDL_CreateWindowAndRenderer("Selective Pressure", WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_RESIZABLE, &window, &renderer)) {
        SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
        return SDL_APP_FAILURE;
    }

    printf("fullscreen: %d",SDL_SetWindowFullscreen(window,true));

    SDL_SetRenderLogicalPresentation(renderer, WINDOW_WIDTH, WINDOW_HEIGHT, SDL_LOGICAL_PRESENTATION_LETTERBOX);

    return SDL_APP_CONTINUE;  /* carry on with the program! */
}

int posx = 10;
int posy = 10;

/* This function runs when a new event (mouse input, keypresses, etc) occurs. */
SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event)
{
    SDL_Event myevent = *event;
    if (myevent.type==SDL_EVENT_KEY_DOWN){
        int keycode = myevent.key.key;
        char keychar = (char)keycode;
        printf("Key: %c Keycode: %d\n",keychar, keycode);

        if (keycode==27){
            return SDL_APP_FAILURE;
            
        }

        switch (keychar){
            case 'w':
                posy-=10;
            break;
            case 's':
posy+=10;
            break;
            case 'd':
posx+=10;
            break;
            case 'a':
posx-=10;
            break;
            
        }
    }

    if (myevent.type == SDL_EVENT_QUIT) {
        return SDL_APP_SUCCESS;  /* end the program, reporting success to the OS. */
    }
    return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once per frame, and is the heart of the program. */
SDL_AppResult SDL_AppIterate(void *appstate)
{
    SDL_SetRenderDrawColor(renderer,100,100,100,SDL_ALPHA_OPAQUE);
    SDL_RenderClear(renderer);

    fill(255,0,0);
    rect(posx,posy,10,10);

    SDL_FRect myrect;
    myrect.x=20;
    myrect.y=20;
    myrect.w=20;
    myrect.h=20;
    SDL_RenderFillRect(renderer,&myrect);

    SDL_RenderPresent(renderer);
    return SDL_APP_CONTINUE;  /* carry on with the program! */
}

/* This function runs once at shutdown. */
void SDL_AppQuit(void *appstate, SDL_AppResult result)
{
    /* SDL will clean up the window/renderer for us. */
}
