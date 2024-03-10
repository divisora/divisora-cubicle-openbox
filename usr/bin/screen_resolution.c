#include <iostream>
#include <X11/Xlib.h>

Display* disp = XOpenDisplay(NULL);
Screen*  scrn = DefaultScreenOfDisplay(disp);
int height = scrn->height;
int width  = scrn->width;

int main() {
    std::cout << "width " << width << " height " << height << "\n";
}