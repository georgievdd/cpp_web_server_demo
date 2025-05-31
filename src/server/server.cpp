#include "./server.h"

crow::Crow<> app;

void run(int port) {
    app.multithreaded().port(port).run();
}
